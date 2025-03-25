variable "cloudfront_config" {
    type = object({
    bucket_name = string
    price_class = string
    custom_domain = string
    acm_certificate_arn = string
  })
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}