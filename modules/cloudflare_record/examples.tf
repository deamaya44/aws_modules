# Example: Create Cloudflare DNS record
module "dns_record" {
  source = "git::https://github.com/deamaya44/aws_modules.git//modules/cloudflare_record?ref=main"

  zone_id = "your-zone-id"
  name    = "api"
  type    = "CNAME"
  content = "example.cloudfront.net"
  ttl     = 1
  proxied = false
  comment = "API Gateway custom domain"
}
