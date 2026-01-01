# SNS Outputs
output "sns_topic_arn" {
  description = "ARN of the orders SNS topic"
  value       = aws_sns_topic.orders.arn
}

output "sns_topic_name" {
  description = "Name of the orders SNS topic"
  value       = aws_sns_topic.orders.name
}

# KMS Outputs
output "kms_key_arn" {
  description = "ARN of the KMS key"
  value       = module.kms.key_arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = module.kms.alias_name
}

# Shipping Queue Outputs
output "shipping_queue_url" {
  description = "URL of the shipping queue"
  value       = module.shipping_queue.queue_url
}

output "shipping_queue_arn" {
  description = "ARN of the shipping queue"
  value       = module.shipping_queue.queue_arn
}

output "shipping_dlq_url" {
  description = "URL of the shipping DLQ"
  value       = module.shipping_queue.dlq_url
}

# Analytics Queue Outputs
output "analytics_queue_url" {
  description = "URL of the analytics queue"
  value       = module.analytics_queue.queue_url
}

output "analytics_queue_arn" {
  description = "ARN of the analytics queue"
  value       = module.analytics_queue.queue_arn
}

output "analytics_dlq_url" {
  description = "URL of the analytics DLQ"
  value       = module.analytics_queue.dlq_url
}
