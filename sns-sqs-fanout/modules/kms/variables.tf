variable "name" {
  description = "Name for the KMS key and alias"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "KMS key name must be between 1 and 256 characters."
  }
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key for SNS/SQS encryption"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction"
  type        = number
  default     = 7

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "Deletion window must be between 7 and 30 days."
  }
}

variable "enable_key_rotation" {
  description = "Whether to enable automatic key rotation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags for the KMS key"
  type        = map(string)
  default     = {}
}
