environment = "dev"
aws_region = "ap-south-1"

cloudfront_config = {
    bucket_name = "zaki-todo-test-ui"
    custom_domain = "test.intellihelper.tech"
    acm_certificate_arn = "arn:aws:acm:us-east-1:688567260640:certificate/2a2758e6-a548-4a0b-ba76-16f21bf43e6d"
    price_class = "PriceClass_100"
}
