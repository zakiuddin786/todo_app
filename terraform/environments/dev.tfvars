environment = "dev"
aws_region = "ap-south-1"

cloudfront_config = {
    bucket_name = "zaki-todo-test-ui"
    custom_domain = "dev.intellihelper.tech"
    acm_certificate_arn = "arn:aws:acm:us-east-1:688567260640:certificate/2a2758e6-a548-4a0b-ba76-16f21bf43e6d"
    price_class = "PriceClass_100"
}

instance_config = {
    vpc_id = "vpc-0d5cf64832addc880",
    instance_type = "t2.micro",
    subnet_ids = ["subnet-024bfbebfa67cb7b3", "subnet-01909f72b0f75df95"]
    instance_count = 2
    ami_id = "ami-002f6e91abff6eb96"
    ssh_key_name = "zaki-test-codonix"
}

alb_config = {
    public_subnet_ids = ["subnet-0a9258c463adf9749", "subnet-024bfbebfa67cb7b3", "subnet-01909f72b0f75df95"]
    certificate_arn = "arn:aws:acm:ap-south-1:688567260640:certificate/d33f7dbb-c39f-4f43-9a34-0e710b3d5d76"
}