output "bucket_name" {
  value = aws_s3_bucket.website.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.website.bucket_domain_name
}
output "origin_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}

output "regional_bucket_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}
