resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = var.validation_method
  subject_alternative_names = var.subject_alternative_names

  tags = var.common_tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  count = var.wait_for_validation ? 1 : 0

  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = var.validation_record_fqdns
}
