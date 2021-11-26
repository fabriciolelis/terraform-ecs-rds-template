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
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "api_endpoint" {
  description = "The dns to api endpoint"
}
