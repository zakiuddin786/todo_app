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