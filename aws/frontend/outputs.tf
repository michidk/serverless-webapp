output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "s3_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}
