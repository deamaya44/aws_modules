# Example: Create ACM certificate with DNS validation
module "acm_cert" {
  source = "git::https://github.com/deamaya44/aws_modules.git//modules/acm_certificate?ref=main"

  domain_name       = "api.example.com"
  validation_method = "DNS"

  common_tags = {
    Environment = "prod"
    Project     = "my-project"
  }
}
