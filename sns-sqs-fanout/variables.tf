variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1)."
  }
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "sns-sqs-fanout"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 32
    error_message = "Project name must be between 1 and 32 characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "kms_deletion_window" {
  description = "KMS key deletion window in days (7-30)"
  type        = number
  default     = 7

  validation {
    condition     = var.kms_deletion_window >= 7 && var.kms_deletion_window <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

variable "queue_message_retention_seconds" {
  description = "Message retention period in seconds (60-1209600)"
  type        = number
  default     = 345600 # 4 days

  validation {
    condition     = var.queue_message_retention_seconds >= 60 && var.queue_message_retention_seconds <= 1209600
    error_message = "Message retention must be between 60 seconds and 14 days."
  }
}

variable "dlq_max_receive_count" {
  description = "Number of receives before message goes to DLQ"
  type        = number
  default     = 3

  validation {
    condition     = var.dlq_max_receive_count >= 1 && var.dlq_max_receive_count <= 1000
    error_message = "Max receive count must be between 1 and 1000."
  }
}
