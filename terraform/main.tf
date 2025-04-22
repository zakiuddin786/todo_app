module "static_website" {
  source = "./modules/s3"
  bucket_name = var.cloudfront_config.bucket_name
  environment = var.environment
}

module "cdn" {
  source = "./modules/cloudfront"
  cloudfront_config = {
    custom_domain = var.cloudfront_config.custom_domain  
    acm_certificate_arn = var.cloudfront_config.acm_certificate_arn
    bucket_name = module.static_website.bucket_name
    bucket_domain_name = module.static_website.bucket_domain_name
    regional_bucket_domain_name =  module.static_website.regional_bucket_domain_name
    origin_access_identity_path = module.static_website.origin_access_identity_path
    price_class = var.cloudfront_config.price_class
  }
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  environment = var.environment
  aws_region = var.aws_region
  aws_account_id = module.ecr.aws_account_id
}
module "ecr" {
  source = "./modules/ecr"
  environment = var.environment
}

module "ec2" {
  source = "./modules/ec2"
  environment = var.environment
  instance_config = {
    ami_id = var.instance_config.ami_id
    instance_type = var.instance_config.instance_type
    vpc_id = var.instance_config.vpc_id
    instance_count = var.instance_config.instance_count
    subnet_ids = var.instance_config.subnet_ids
    instance_profile_name =  module.iam.instance_profile_name
    alb_security_group_id = module.alb.alb_security_group_id
    target_group_arn = module.alb.target_group_arn
    ssh_key_name = var.instance_config.ssh_key_name
  }

}
module "alb" {
  source = "./modules/alb"
  environment = var.environment

  alb_config = {
    vpc_id = var.instance_config.vpc_id
    public_subnet_ids = var.alb_config.public_subnet_ids
    certificate_arn = var.alb_config.certificate_arn
  }
}

module "monitoring" {
  source = "./modules/monitoring"
  environment = var.environment
  instance_config = {
    ami_id = var.instance_config.ami_id
    instance_type = var.instance_config.instance_type
    vpc_id = var.instance_config.vpc_id
    instance_count = 1
    subnet_ids = var.instance_config.subnet_ids
    instance_profile_name =  module.iam.instance_profile_name
    alb_security_group_id = module.alb.alb_security_group_id
    target_group_arn = module.alb.target_group_arn
    ssh_key_name = var.instance_config.ssh_key_name
  }

}