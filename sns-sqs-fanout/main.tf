# KMS Module
module "kms" {
  source = "./modules/kms"

  name                    = "${local.name_prefix}-messaging-key"
  description             = "KMS key for ${var.project_name} SNS/SQS encryption"
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = true
  tags                    = local.common_tags
}

# SNS Topic
resource "aws_sns_topic" "orders" {
  name              = "${local.name_prefix}-orders"
  kms_master_key_id = module.kms.key_id

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-orders" })
}

# Shipping Queue
module "shipping_queue" {
  source = "./modules/standard_queue"

  name                      = local.queues.shipping.name
  kms_key_arn               = module.kms.key_arn
  sns_topic_arn             = aws_sns_topic.orders.arn
  message_retention_seconds = var.queue_message_retention_seconds
  max_receive_count         = var.dlq_max_receive_count
  tags                      = merge(local.common_tags, { Purpose = local.queues.shipping.description })
}

# Analytics Queue
module "analytics_queue" {
  source = "./modules/standard_queue"

  name                      = local.queues.analytics.name
  kms_key_arn               = module.kms.key_arn
  sns_topic_arn             = aws_sns_topic.orders.arn
  message_retention_seconds = var.queue_message_retention_seconds
  max_receive_count         = var.dlq_max_receive_count
  tags                      = merge(local.common_tags, { Purpose = local.queues.analytics.description })
}
