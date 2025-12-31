#!/bin/bash
set -e

# Configuration
REGION="us-east-1"
FUNCTION_NAME="serverless-api-dynamodb-function"
APP_NAME="${FUNCTION_NAME}-codedeploy-app"
DEPLOYMENT_GROUP="${FUNCTION_NAME}-deployment-group"
ALIAS_NAME="live"
TERRAFORM_DIR="../terraform"

# Ensure we are in the scripts directory or adjust paths
if [ ! -d "$TERRAFORM_DIR" ]; then
    echo "Error: Cannot find terraform directory at $TERRAFORM_DIR"
    echo "Please run this script from the 'scripts' directory."
    exit 1
fi

# 1. Get API Endpoint
echo "--- Getting API Endpoint ---"
API_ENDPOINT=$(cd $TERRAFORM_DIR && terraform output -raw api_endpoint)
echo "API Endpoint: $API_ENDPOINT"

# 1.5 Optional: Bump Version
echo ""
read -p "Do you want to publish a new version before deploying? (y/n) " -n 1 -r < /dev/tty
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "--- Bumping Version ---"
    # Update Lambda Code (simple timestamp injection to force change)
    # Try updating 'Running on v...'
    sed -i "s/Running on v[0-9]*/Running on v$(date +%s)/" ../lambda/main.py
    # Try updating 'Welcome to...' (non-greedy match)
    sed -i "s/Welcome to the Serverless API v[^']*/Welcome to the Serverless API v$(date +%s)/" ../lambda/main.py
    
    # Force change by appending comment (guarantees hash change)
    echo "" >> ../lambda/main.py
    echo "# Updated at $(date)" >> ../lambda/main.py

    echo "Updated lambda/main.py with new timestamp."
    
    # Run Terraform to publish version
    echo "Running Terraform plan..."
    (cd $TERRAFORM_DIR && terraform plan --out=tfplan)
    echo "Running Terraform Apply..."
    (cd $TERRAFORM_DIR && terraform apply tfplan)
    echo "Version published."
fi

# 2. Get available versions (excluding $LATEST)
echo ""
echo "--- Fetching Lambda Versions ---"
VERSIONS=$(aws lambda list-versions-by-function \
    --function-name $FUNCTION_NAME \
    --region $REGION \
    --query "Versions[?Version!='\$LATEST'].Version" \
    --output text | tr '\t' '\n' | sort -V)

echo "Available versions:"
echo "$VERSIONS"

# Get Current Alias Version
echo "--- Fetching Alias Status ---"
CURRENT_ALIAS_VER=$(aws lambda get-alias --function-name $FUNCTION_NAME --name $ALIAS_NAME --region $REGION --query 'FunctionVersion' --output text)
echo "Alias '$ALIAS_NAME' is currently on version: $CURRENT_ALIAS_VER"

if [ "$CURRENT_ALIAS_VER" == "\$LATEST" ]; then
    echo "Error: Alias is pointing to \$LATEST, cannot perform canary."
    exit 1
fi

OLD_VER=$CURRENT_ALIAS_VER

# Get Newest Version (that is NOT what alias is pointing to)
# We want the highest version number that is greater than OLD_VER
NEW_VER=$(echo "$VERSIONS" | grep -v "$OLD_VER" | tail -n 1)

if [ -z "$NEW_VER" ] || [ "$NEW_VER" == "$OLD_VER" ]; then
    echo "Error: No new version found to deploy to. Current: $OLD_VER"
    echo "Available: $VERSIONS"
    exit 1
fi

echo "Preparing to shift traffic from v$OLD_VER to v$NEW_VER"
read -p "Do you want to proceed? (y/n) " -n 1 -r < /dev/tty
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# 3. Create Revision JSON
echo ""
echo "--- Creating Revision JSON ---"
REVISION_FILE="$TERRAFORM_DIR/revision_auto.json"

# Construct specific JSON for Lambda AppSpec
jq -n \
  --arg name "$FUNCTION_NAME" \
  --arg alias "$ALIAS_NAME" \
  --arg current "$OLD_VER" \
  --arg target "$NEW_VER" \
  '{
    revisionType: "AppSpecContent",
    appSpecContent: {
      content: {
        version: 0.0,
        Resources: [{
          myLambdaFunction: {
            Type: "AWS::Lambda::Function",
            Properties: {
              Name: $name,
              Alias: $alias,
              CurrentVersion: $current,
              TargetVersion: $target
            }
          }
        }]
      } | tojson
    }
  }' > "$REVISION_FILE"

echo "Created $REVISION_FILE"

# 4. Trigger Deployment
echo ""
echo "--- Triggering CodeDeploy ---"
DEPLOYMENT_ID=$(aws deploy create-deployment \
  --application-name $APP_NAME \
  --deployment-group-name $DEPLOYMENT_GROUP \
  --revision "file://$REVISION_FILE" \
  --region $REGION \
  --output text \
  --query "deploymentId")

echo "Deployment triggered: $DEPLOYMENT_ID"
echo "Check console: https://$REGION.console.aws.amazon.com/codesuite/codedeploy/deployments/$DEPLOYMENT_ID?region=$REGION"

# 5. Monitor Traffic
echo ""
echo "--- Monitoring Traffic (Ctrl+C to stop) ---"
echo "Sending requests to $API_ENDPOINT/ ..."

while true; do
    RESPONSE=$(curl -s "$API_ENDPOINT/")
    # Extract message or version if possible, here we just print the response
    # Assuming response JSON format: {"message": "..."}
    echo "[$(date +'%T')] $RESPONSE"
    sleep 1
done
