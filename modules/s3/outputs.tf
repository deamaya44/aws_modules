# S3 Bucket Outputs
output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "bucket_region" {
  description = "The region of the S3 bucket"
  value       = aws_s3_bucket.this.region
}

output "versioning_enabled" {
  description = "Whether versioning is enabled on the S3 bucket"
  value       = var.versioning
}

output "public_access_blocked" {
  description = "Whether public access is blocked on the S3 bucket"
  value       = var.block_public_access
}