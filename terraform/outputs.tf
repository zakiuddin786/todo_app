resource "local_file" "inventory_file" {
  content = templatefile("./inventory.template", 
  {
    ec2_public_dns = module.ec2.backend_public_dns
    aws_region = var.aws_region
    backend_ecr_uri = module.ecr.backend_ecr_uri
    environment = var.environment
    role_arn = module.iam.ec2_role_arn
    aws_account_id = module.ecr.aws_account_id
  })
  filename = "../ansible/inventory"
}