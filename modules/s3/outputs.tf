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

# CRR Outputs
output "crr_enabled" {
  description = "Whether Cross-Region Replication is enabled"
  value       = var.enable_crr
}

output "crr_role_arn" {
  description = "ARN of the IAM role used for Cross-Region Replication"
  value       = var.crr_role_arn
}

output "crr_destination_bucket" {
  description = "Destination bucket for Cross-Region Replication"
  value       = var.crr_destination_bucket
  sensitive   = true
}

# Encryption Outputs
output "encryption_enabled" {
  description = "Whether server-side encryption is enabled"
  value       = var.enable_server_side_encryption
}

output "kms_key_id" {
  description = "KMS key ID used for encryption"
  value       = var.kms_key_id
  sensitive   = true
}