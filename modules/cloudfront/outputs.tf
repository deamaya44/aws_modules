output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "distribution_hosted_zone_id" {
  description = "CloudFront Route 53 hosted zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "distribution_status" {
  description = "Status of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.status
}

output "oai_iam_arn" {
  description = "IAM ARN of the Origin Access Identity"
  value       = var.create_oai ? aws_cloudfront_origin_access_identity.this[0].iam_arn : null
}

output "oai_cloudfront_path" {
  description = "CloudFront path of the Origin Access Identity"
  value       = var.create_oai ? aws_cloudfront_origin_access_identity.this[0].cloudfront_access_identity_path : null
}
