########### Sample main.tf file for using AWS modules ###########

# module "vpc" {
# source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/vpc?ref=main"
# #   for_each = local.vpc --- Uncomment this, when you set the locals ---
#   # VPC Configuration
#   vpc_name             = each.key
#   vpc_cidr             = each.value.vpc_cidr
#   enable_dns_hostnames = each.value.enable_dns_hostnames
#   enable_dns_support   = each.value.enable_dns_support

#   # Internet Gateway
#   create_igw = each.value.create_igw

#   # Subnets
#   public_subnet_cidrs     = each.value.public_subnet_cidrs
#   private_subnet_cidrs    = each.value.private_subnet_cidrs
#   availability_zones      = each.value.availability_zones
#   map_public_ip_on_launch = each.value.map_public_ip_on_launch

#   # NAT Gateway
#   create_nat_gateway = each.value.create_nat_gateway
#   create_s3_endpoint = each.value.create_s3_endpoint

#   # Common Tags
#   common_tags = each.value.tags
# }