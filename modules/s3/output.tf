
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.root_s3_distribution.domain_name
}
