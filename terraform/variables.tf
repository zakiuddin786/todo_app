variable "cloudfront_config" {
    type = object({
    bucket_name = string
    price_class = string
    custom_domain = string
    acm_certificate_arn = string
  })
}

variable "alb_config" {
  type = object({
    public_subnet_ids = list(string)
    certificate_arn = string
  })
}

variable "instance_config" {
  type = object({
    vpc_id = string
    ami_id = string,
    instance_count = number,
    subnet_ids = list(string),
    ssh_key_name = string,
    instance_type = string
  })
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}