# SNS-SQS Fanout Architecture

Production-grade SNS-SQS fanout pattern with Terraform best practices.

## Architecture

```
                    ┌─────────────────┐
                    │   SNS Topic     │
                    │   (Orders)      │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
       ┌──────────┐   ┌──────────┐   ┌──────────┐
       │ Shipping │   │Analytics │   │  More    │
       │  Queue   │   │  Queue   │   │ Queues.. │
       └────┬─────┘   └────┬─────┘   └──────────┘
            │              │
            ▼              ▼
       ┌──────────┐   ┌──────────┐
       │   DLQ    │   │   DLQ    │
       └──────────┘   └──────────┘
```

All resources encrypted with KMS CMK.

## Dead Letter Queue (DLQ)

### What is a Dead Letter Queue?

A **Dead Letter Queue (DLQ)** is a special queue that captures messages that cannot be processed successfully after a specified number of attempts. It acts as a safety net for the message processing system.

### Why We Implement DLQ

| Problem | DLQ Solution |
|---------|--------------|
| **Poison Pill Messages** | Messages that always fail (malformed data, bugs) are moved to DLQ instead of blocking the main queue forever |
| **Infinite Retry Loops** | Without DLQ, a failing message keeps returning to the queue, wasting resources |
| **Debugging & Analysis** | Failed messages are preserved in DLQ for investigation |
| **Queue Health** | Main queue stays healthy and processes valid messages |

### How It Works

1. A message is received from the main queue
2. If processing fails, the message becomes visible again after the visibility timeout
3. After `max_receive_count` failures (default: 3), the message is automatically moved to DLQ
4. Messages in DLQ can be analyzed, fixed, and optionally redriven back to the main queue

### Test DLQ Behavior

Run the simulation script:

```bash
cd terraform
./scripts/simulate_dlq.sh
```

This script:
1. Publishes a test message to SNS
2. Simulates 3 processing failures (receives without deleting)
3. Verifies the message appears in the DLQ

## Quick Start

```bash
cd terraform

# Initialize
terraform init

# Review plan
terraform plan --out=tfplan

# Deploy
terraform apply tfplan
```

## Test Fanout

```bash
# Publish message
aws sns publish \
  --topic-arn "$(terraform output -raw sns_topic_arn)" \
  --message '{"order_id": "12345"}'

# Check shipping queue
aws sqs receive-message \
  --queue-url "$(terraform output -raw shipping_queue_url)" \
  --wait-time-seconds 5

# Check analytics queue
aws sqs receive-message \
  --queue-url "$(terraform output -raw analytics_queue_url)" \
  --wait-time-seconds 5
```

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and customize:

| Variable | Description | Default |
|----------|-------------|---------|
| aws_region | AWS region | us-east-1 |
| project_name | Project identifier | sns-sqs-fanout |
| environment | dev/staging/prod | dev |
| kms_deletion_window | KMS key deletion window (7-30 days) | 7 |
| queue_message_retention_seconds | Message retention | 345600 (4 days) |
| dlq_max_receive_count | Receives before DLQ | 3 |

## Cleanup

```bash
terraform destroy -auto-approve
```
