resource "aws_sqs_queue" "dlq" {
  name                              = "${var.name}-dlq"
  message_retention_seconds         = var.dlq_message_retention_seconds
  kms_master_key_id                 = var.kms_key_arn
  kms_data_key_reuse_period_seconds = 300

  tags = merge(var.tags, { Name = "${var.name}-dlq", Type = "DLQ" })
}

resource "aws_sqs_queue" "main" {
  name                              = var.name
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  kms_master_key_id                 = var.kms_key_arn
  kms_data_key_reuse_period_seconds = 300

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(var.tags, { Name = var.name, Type = "Main" })
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${var.name}-policy"
    Statement = [
      {
        Sid    = "AllowSNSMessages"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.main.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.sns_topic_arn
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn            = var.sns_topic_arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.main.arn
  raw_message_delivery = true
}
