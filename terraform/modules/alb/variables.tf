variable "environment" {
  type = string
}

variable "alb_config" {
  type = object({
    public_subnet_ids = list(string)
    vpc_id = string
    certificate_arn = string
  })
}