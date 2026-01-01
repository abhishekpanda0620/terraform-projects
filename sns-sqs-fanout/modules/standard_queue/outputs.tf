output "queue_id" {
  description = "The URL/ID of the main SQS queue"
  value       = aws_sqs_queue.main.id
}

output "queue_arn" {
  description = "The ARN of the main SQS queue"
  value       = aws_sqs_queue.main.arn
}

output "queue_url" {
  description = "The URL of the main SQS queue"
  value       = aws_sqs_queue.main.url
}

output "queue_name" {
  description = "The name of the main SQS queue"
  value       = aws_sqs_queue.main.name
}

output "dlq_id" {
  description = "The URL/ID of the dead letter queue"
  value       = aws_sqs_queue.dlq.id
}

output "dlq_arn" {
  description = "The ARN of the dead letter queue"
  value       = aws_sqs_queue.dlq.arn
}

output "dlq_url" {
  description = "The URL of the dead letter queue"
  value       = aws_sqs_queue.dlq.url
}

output "subscription_arn" {
  description = "The ARN of the SNS subscription"
  value       = aws_sns_topic_subscription.this.arn
}
