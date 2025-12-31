output "upload_bucket_id" {
    value = aws_s3_bucket.upload_bucket.id
}

output "upload_bucket_arn" {
    value = aws_s3_bucket.upload_bucket.arn
}

output "processed_bucket_id" {
    value = aws_s3_bucket.processed_bucket.id
}

output "processed_bucket_arn" {
    value = aws_s3_bucket.processed_bucket.arn
}
