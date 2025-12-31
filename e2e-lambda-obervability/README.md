# End-to-End Lambda Observability & Image Processing

A robust, serverless image processing application featuring a complete **Observability Pipeline**. This project demonstrates how to build, monitor, and alert on serverless architectures using AWS Lambda, S3, CloudWatch, and SNS.


## 🏗️ Architecture

1.  **Ingestion**: S3 Bucket triggers Lambda on object creation.
2.  **Processing**: Python Lambda function (with Pillow layer) resizes and reformats images.
3.  **Observability**:
    *   **CloudWatch Logs**: Captures application logs.
    *   **Metric Filters**: Extracts custom metrics (Processing Time, Image Size, Errors) from logs.
    *   **CloudWatch Alarms**: Monitors critical thresholds (Errors, Duration, Throttling).
    *   **SNS Notifications**: Sends Email alerts to operators.

## 🚀 Features

*   **Modular Terraform**: Clean separation of concerns (`s3`, `lambda`, `cloudwatch_metrics`, `cloudwatch_alarms`, `log_alerts`, `sns`).
*   **Custom Metrics**: Tracks business logic metrics beyond standard AWS metrics.
*   **Granular Alerting**: Notifies on specific log patterns (e.g., "Memory limit exceeded", "PIL Error").
*   **Dashboarding**: Automated CloudWatch Dashboard creation.
*   **Automated Recovery**: Includes scripts to manage state and cleanup.

## 🛠️ Usage

### 1. Build the Lambda Layer
```bash
cd scripts
./build_layer.sh
```

### 2. Configure & Deploy
```bash
cd terraform
# Copy the example tfvars file
cp terraform.tfvars.example terraform.tfvars

# Edit the file to add your email address
# nano terraform.tfvars 

terraform init
terraform apply
```

### 3. Verify System
The deployment outputs commands you can run to test the system.

**Trigger an Alarm (Manual Test):**
```bash
aws cloudwatch set-alarm-state --alarm-name <alarm-name-from-output> --state-value ALARM --state-reason "Testing"
```

**Trigger a Real Failure (End-to-End Test):**
Upload a corrupted image to verify log parsing and alerting.
```bash
echo "not an image" > bad.jpg
aws s3 cp bad.jpg s3://<upload-bucket-name>/
```

## 📂 Modules Overview

| Module | Description |
|Args|Description|
|---|---|
| `s3` | Source and Destination buckets with versioning. |
| `lambda` | Image processing function with IAM roles and Layers. |
| `sns` | Topcis for Critical, Performance, and Log alerts. |
| `cloudwatch_metrics` | Metric Filters to extract data from logs. |
| `cloudwatch_alarms` | Alarms for metrics (Errors, Duration). |
| `log_alerts` | Pattern-based alerts (Timeout, Memory, Permissions). |
