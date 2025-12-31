resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_prefix        = "${var.project_name}-${var.environment}"
  upload_bucket_name   = "${local.bucket_prefix}-upload-${random_id.suffix.hex}"
  processed_bucket_name = "${local.bucket_prefix}-processed-${random_id.suffix.hex}"
  lambda_function_name = "${var.project_name}-${var.environment}-processor"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedBy   = "Abhishek Panda"
    CreatedAt   = timestamp()
  }
}
# ============================================================================
# MODULE: S3
# Creates S3 buckets for upload and processed files
# ============================================================================

module "s3" {
  source = "./modules/s3"
  
  upload_bucket_name    = local.upload_bucket_name
  processed_bucket_name = local.processed_bucket_name

  tags = local.common_tags
}

# ============================================================================
# MODULE: LAMBDA
# Creates Lambda function for image processing
# ============================================================================

module "lambda" {
  source = "./modules/lambda"
  
  project_name         = var.project_name
  lambda_function_name = local.lambda_function_name
  upload_bucket_arn    = module.s3.upload_bucket_arn
  processed_bucket_id  = module.s3.processed_bucket_id
  processed_bucket_arn = module.s3.processed_bucket_arn
  aws_region           = var.aws_region
}

# ============================================================================
# MODULE: SNS
# Creates SNS topics for alerts
# ============================================================================

module "sns" {
  source = "./modules/sns"

  project_name            = var.project_name
  environment             = var.environment
  critical_alert_email    = var.alert_email
  performance_alert_email = var.alert_email
  log_alert_email         = var.alert_email
  critical_alert_sms      = var.alert_sms

  tags = local.common_tags
}

# ============================================================================
# S3 Notification (Tying S3 and Lambda together)
# ============================================================================

resource "aws_s3_bucket_notification" "upload_bucket_notification" {
  bucket = module.s3.upload_bucket_id

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""
  }

  depends_on = [aws_lambda_permission.allow_s3_notification]
}

resource "aws_lambda_permission" "allow_s3_notification" {
  statement_id  = "AllowS3Notification"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3.upload_bucket_arn
}


# ============================================================================
# MODULE: CLOUDWATCH METRICS
# Creates custom metrics, metric filters, and dashboard
# ============================================================================

module "cloudwatch_metrics" {
  source = "./modules/cloudwatch_metrics"

  function_name    = module.lambda.lambda_function_name
  log_group_name   = module.lambda.log_group_name
  metric_namespace = var.metric_namespace
  aws_region       = var.aws_region
  enable_dashboard = var.enable_cloudwatch_dashboard

  # tags not supported by cloudwatch_metrics module

}

# ============================================================================
# MODULE: CLOUDWATCH ALARMS
# Creates CloudWatch alarms for Lambda monitoring
# ============================================================================

module "cloudwatch_alarms" {
  source = "./modules/cloudwatch_alarms"

  function_name                = module.lambda.lambda_function_name
  critical_alerts_topic_arn    = module.sns.critical_alerts_topic_arn
  performance_alerts_topic_arn = module.sns.performance_alerts_topic_arn
  metric_namespace             = var.metric_namespace

  # Alarm thresholds
  error_threshold                 = var.error_threshold
  duration_threshold_ms           = var.duration_threshold_ms
  throttle_threshold              = var.throttle_threshold
  concurrent_executions_threshold = var.concurrent_executions_threshold
  log_error_threshold             = var.log_error_threshold
  enable_no_invocation_alarm      = var.enable_no_invocation_alarm

  tags = local.common_tags
}

# ============================================================================
# MODULE: LOG ALERTS
# Creates log-based metric filters and alarms for specific error patterns
# ============================================================================

module "log_alerts" {
  source = "./modules/log_alerts"

  function_name        = module.lambda.lambda_function_name
  log_group_name       = module.lambda.log_group_name
  log_alerts_topic_arn = module.sns.log_alerts_topic_arn
  metric_namespace     = var.metric_namespace

  tags = local.common_tags
}