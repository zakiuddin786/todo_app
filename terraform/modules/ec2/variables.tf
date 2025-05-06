variable "instance_config" {
    type = object({
      ami_id = string,
      instance_type = string,
      vpc_id = string
      instance_count = number,
      subnet_ids = list(string),
      instance_profile_name = string,
      alb_security_group_id = string
      ssh_key_name = string,
      target_group_arn = string
    })
}

variable "environment" {
  type = string
}

variable "monitoring_security_group_id" {
  type = string
}