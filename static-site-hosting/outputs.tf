output "static_site_hosting_url" {
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "static_site_hosting_bucket_name" {
    value = aws_s3_bucket.static-site-hosting.bucket
}
    