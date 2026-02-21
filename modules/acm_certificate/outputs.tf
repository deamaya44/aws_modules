output "certificate_arn" {
  description = "ARN of the certificate"
  value       = aws_acm_certificate.this.arn
}

output "certificate_id" {
  description = "ID of the certificate"
  value       = aws_acm_certificate.this.id
}

output "domain_validation_options" {
  description = "Domain validation options"
  value       = aws_acm_certificate.this.domain_validation_options
}

output "validation_arn" {
  description = "ARN of validated certificate"
  value       = var.wait_for_validation ? aws_acm_certificate_validation.this[0].certificate_arn : null
}
