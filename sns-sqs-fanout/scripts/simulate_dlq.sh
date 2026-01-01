#!/bin/bash
# simulate_dlq.sh - Simulate Dead Letter Queue behavior
# This script demonstrates how messages move to DLQ after max_receive_count failures

set -e

# Change to the terraform directory (parent of scripts)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Dead Letter Queue (DLQ) Simulation Script          ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get queue URLs from Terraform outputs
SHIPPING_QUEUE_URL=$(terraform output -raw shipping_queue_url)
SHIPPING_DLQ_URL=$(terraform output -raw shipping_dlq_url)
SNS_TOPIC_ARN=$(terraform output -raw sns_topic_arn)
MAX_RECEIVE_COUNT=3  # Matches our Terraform configuration

echo -e "${YELLOW}Configuration:${NC}"
echo "  Main Queue: $SHIPPING_QUEUE_URL"
echo "  DLQ:        $SHIPPING_DLQ_URL"
echo "  Max Receive Count: $MAX_RECEIVE_COUNT"
echo ""

# Step 1: Publish a test message
echo -e "${BLUE}Step 1: Publishing test message to SNS...${NC}"
MESSAGE_ID=$(aws sns publish \
  --topic-arn "$SNS_TOPIC_ARN" \
  --message '{"order_id": "DLQ-TEST-001", "action": "simulate_failure"}' \
  --query 'MessageId' --output text)
echo -e "${GREEN}✓ Published message: $MESSAGE_ID${NC}"
echo ""

# Wait for message to arrive
sleep 2

# Step 2: Simulate processing failures (receive but don't delete)
echo -e "${BLUE}Step 2: Simulating $MAX_RECEIVE_COUNT processing failures...${NC}"
echo -e "${YELLOW}(Receiving message without deleting to simulate failures)${NC}"
echo ""

for i in $(seq 1 $MAX_RECEIVE_COUNT); do
  echo -e "${YELLOW}Attempt $i of $MAX_RECEIVE_COUNT:${NC}"
  
  # Receive message (with short visibility timeout for faster demo)
  RESULT=$(aws sqs receive-message \
    --queue-url "$SHIPPING_QUEUE_URL" \
    --visibility-timeout 1 \
    --wait-time-seconds 5 \
    --query 'Messages[0].Body' --output text 2>/dev/null || echo "null")
  
  if [ "$RESULT" != "null" ] && [ -n "$RESULT" ]; then
    echo -e "  ${RED}✗ Processing failed! Message body: $RESULT${NC}"
    echo "  (Message returned to queue after visibility timeout)"
  else
    echo -e "  ${YELLOW}⏳ Message not yet visible (in visibility timeout)${NC}"
  fi
  
  # Wait for visibility timeout to expire
  echo "  Waiting for visibility timeout..."
  sleep 2
  echo ""
done

# Step 3: Check if message moved to DLQ
echo -e "${BLUE}Step 3: Checking Dead Letter Queue...${NC}"
sleep 3

DLQ_MESSAGE=$(aws sqs receive-message \
  --queue-url "$SHIPPING_DLQ_URL" \
  --wait-time-seconds 5 \
  --query 'Messages[0]' --output json 2>/dev/null || echo "null")

if [ "$DLQ_MESSAGE" != "null" ] && [ -n "$DLQ_MESSAGE" ]; then
  echo -e "${GREEN}✓ Message successfully moved to DLQ!${NC}"
  echo ""
  echo -e "${YELLOW}DLQ Message Details:${NC}"
  echo "$DLQ_MESSAGE" | jq '.'
  
  # Get receipt handle and delete the message to clean up
  RECEIPT_HANDLE=$(echo "$DLQ_MESSAGE" | jq -r '.ReceiptHandle')
  aws sqs delete-message \
    --queue-url "$SHIPPING_DLQ_URL" \
    --receipt-handle "$RECEIPT_HANDLE" 2>/dev/null || true
  echo -e "${GREEN}✓ DLQ message cleaned up${NC}"
else
  echo -e "${YELLOW}⏳ Message not yet in DLQ. It may take a few more seconds.${NC}"
  echo "Try running: aws sqs receive-message --queue-url \"$SHIPPING_DLQ_URL\" --wait-time-seconds 10"
fi

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    Simulation Complete                     ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "  The DLQ (Dead Letter Queue) captures messages that cannot be"
echo "  processed successfully after $MAX_RECEIVE_COUNT attempts."
echo ""
echo "  This prevents 'poison pill' messages from blocking the queue"
echo "  and allows you to investigate failures separately."
