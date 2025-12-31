resource "aws_cloudwatch_log_metric_filter" "timeout" {
  name           = "${var.function_name}-timeout"
  pattern        = "\"Task timed out\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "TimeoutCount"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "timeout_alarm" {
  alarm_name          = "${var.function_name}-timeout-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TimeoutCount"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors lambda timeouts"
  alarm_actions       = [var.log_alerts_topic_arn]
}

resource "aws_cloudwatch_log_metric_filter" "memory" {
  name           = "${var.function_name}-memory"
  pattern        = "\"Memory limit exceeded\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "MemoryErrorCount"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "${var.function_name}-memory-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "MemoryErrorCount"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors lambda memory errors"
  alarm_actions       = [var.log_alerts_topic_arn]
}

resource "aws_cloudwatch_log_metric_filter" "pil" {
  name           = "${var.function_name}-pil"
  pattern        = "\"PIL\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "PILErrors"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "pil_alarm" {
  alarm_name          = "${var.function_name}-pil-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "PILErrors"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors PIL related image processing errors"
  alarm_actions       = [var.log_alerts_topic_arn]
}

resource "aws_cloudwatch_log_metric_filter" "s3_permission" {
  name           = "${var.function_name}-s3-permission"
  pattern        = "\"AccessDenied\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "S3PermissionErrors"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_permission_alarm" {
  alarm_name          = "${var.function_name}-s3-permission-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "S3PermissionErrors"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors S3 permission errors"
  alarm_actions       = [var.log_alerts_topic_arn]
}

resource "aws_cloudwatch_log_metric_filter" "critical" {
  name           = "${var.function_name}-critical"
  pattern        = "\"CRITICAL\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "CriticalErrors"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "critical_alarm" {
  alarm_name          = "${var.function_name}-critical-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CriticalErrors"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors critical log messages"
  alarm_actions       = [var.log_alerts_topic_arn]
}

resource "aws_cloudwatch_log_metric_filter" "large_image" {
  name           = "${var.function_name}-large-image"
  pattern        = "\"Image size too large\""
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "LargeImageCount"
    namespace = var.metric_namespace
    value     = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "large_image_alarm" {
  alarm_name          = "${var.function_name}-large-image-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "LargeImageCount"
  namespace           = var.metric_namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "This metric monitors large image upload attempts"
  alarm_actions       = [var.log_alerts_topic_arn]
}