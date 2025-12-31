output "upload_bucket_name" {
  description = "S3 bucket for uploading images (SOURCE)"
  value       = module.s3.upload_bucket_id
}

output "processed_bucket_name" {
  description = "S3 bucket for processed images (DESTINATION)"
  value       = module.s3.processed_bucket_id
}

output "lambda_function_name" {
  description = "Lambda function name for image processing"
  value       = module.lambda.lambda_function_name
}

output "region" {
  description = "AWS Region"
  value       = var.aws_region
}

output "upload_command_example" {
  description = "Example command to upload an image"
  value       = "aws s3 cp your-image.jpg s3://${module.s3.upload_bucket_id}/"
}