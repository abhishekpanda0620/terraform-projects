variable "name" {
  description = "Name of the SQS queue"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 80
    error_message = "Queue name must be between 1 and 80 characters."
  }
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to subscribe to"
  type        = string
}

variable "message_retention_seconds" {
  description = "Message retention period in seconds"
  type        = number
  default     = 345600

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "Message retention must be between 60 seconds and 14 days."
  }
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds"
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "Visibility timeout must be between 0 and 12 hours."
  }
}

variable "max_receive_count" {
  description = "Number of receives before message goes to DLQ"
  type        = number
  default     = 3

  validation {
    condition     = var.max_receive_count >= 1 && var.max_receive_count <= 1000
    error_message = "Max receive count must be between 1 and 1000."
  }
}

variable "dlq_message_retention_seconds" {
  description = "DLQ message retention period in seconds"
  type        = number
  default     = 1209600

  validation {
    condition     = var.dlq_message_retention_seconds >= 60 && var.dlq_message_retention_seconds <= 1209600
    error_message = "DLQ message retention must be between 60 seconds and 14 days."
  }
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
