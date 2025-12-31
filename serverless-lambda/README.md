# Serverless Image Processor

A serverless application that processes images using AWS Lambda and S3. Triggered by S3 object uploads, it uses a Python Lambda function (with Pillow library layer) to process images.

## Architecture

*   **S3 Upload Bucket**: Source bucket for raw images.
*   **S3 Processed Bucket**: Destination bucket for processed images.
*   **AWS Lambda**: Python 3.13 function that processes images (resize, format conversion).
*   **Lambda Layer**: Contains the `Pillow` library for image manipulation.
*   **CloudWatch Logs**: Logs execution details of the Lambda function.

## Modular Structure

The project is refactored into Terraform modules for reusability:

*   `modules/s3`: Manages S3 buckets, versioning, encryption, and public access blocks.
*   `modules/lambda`: Manages Lambda function, Layer, IAM Roles/Policies, and CloudWatch Group.

## Prerequisites

*   Terraform >= 1.0
*   AWS CLI configured
*   Docker (for building the Lambda layer)

## Usage

### 1. Build the Lambda Layer
Use the provided script to build the Pillow layer compatible with Amazon Linux 2023 (Python 3.13).

```bash
cd scripts
./build_layer.sh
```

### 2. Deploy Infrastructure
Initialize and apply the Terraform configuration.

```bash
cd terraform
terraform init
terraform apply
```

### 3. Test
Upload an image to the upload bucket. The output command will be provided by Terraform.

```bash
# Example
aws s3 cp input.jpg s3://<upload-bucket-name>/
```

Check the processed bucket for the output.

### 4. Cleanup
To destroy all resources, run the destroy script. **Note: This script blindly empties the buckets before destroying them.**

```bash
cd scripts
./destroy.sh
```
