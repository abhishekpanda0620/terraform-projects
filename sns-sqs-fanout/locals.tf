locals {
  name_prefix = "${var.project_name}-${var.environment}"

  queues = {
    shipping = {
      name        = "${local.name_prefix}-shipping"
      description = "Order shipping notifications"
    }
    analytics = {
      name        = "${local.name_prefix}-analytics"
      description = "Order analytics events"
    }
  }

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}
