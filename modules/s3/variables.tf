variable "domain_name" {
  description = "Domain name"
}

variable "bucket_name" {
  description = "Bucket name"
}

variable "zone_id" {
  description = "Zone ID"
}

variable "tsl_certificate_arn" {
  description = "ARN of the ACM certificate CloudFront serves, which must live in us-east-1"
}

variable "api_endpoint" {
  description = "The dns to api endpoint"
}
