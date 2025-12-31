variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
}

variable "metric_namespace" {
  description = "Namespace for custom metrics"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "enable_dashboard" {
  description = "Whether to create the CloudWatch dashboard"
  type        = bool
  default     = true
}

variable "critical_alert_email" {
  description = "Email address for critical alerts (errors, failures)"
  type        = string
  default     = ""
}

variable "performance_alert_email" {
  description = "Email address for performance alerts (duration, memory)"
  type        = string
  default     = ""
}

variable "log_alert_email" {
  description = "Email address for log-based alerts"
  type        = string
  default     = ""
}

variable "critical_alert_sms" {
  description = "Phone number for critical SMS alerts (format: +1234567890)"
  type        = string
  default     = ""
}
