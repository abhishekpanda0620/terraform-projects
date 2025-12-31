resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_prefix        = "${var.project_name}-${var.environment}"
  upload_bucket_name   = "${local.bucket_prefix}-upload-${random_id.suffix.hex}"
  processed_bucket_name = "${local.bucket_prefix}-processed-${random_id.suffix.hex}"
  lambda_function_name = "${var.project_name}-${var.environment}-processor"
}

module "s3" {
  source = "./modules/s3"
  
  upload_bucket_name    = local.upload_bucket_name
  processed_bucket_name = local.processed_bucket_name
}

module "lambda" {
  source = "./modules/lambda"
  
  project_name         = var.project_name
  lambda_function_name = local.lambda_function_name
  upload_bucket_arn    = module.s3.upload_bucket_arn
  processed_bucket_id  = module.s3.processed_bucket_id
  processed_bucket_arn = module.s3.processed_bucket_arn
  aws_region           = var.aws_region
}

# S3 Notification (Tying S3 and Lambda together)
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