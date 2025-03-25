variable "cloudfront_config" {
  type = object({
    bucket_domain_name = string
    regional_bucket_domain_name = string
    bucket_name = string
    origin_access_identity_path = string
    price_class = string
    custom_domain = string
    acm_certificate_arn = string
  })
}

variable "environment" {
  type = string
}