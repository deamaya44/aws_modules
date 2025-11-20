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


# module "s3" {
#   source     = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/s3?ref=main"
#   for_each   = local.s3_buckets
#   name       = each.key
#   versioning = each.value.versioning
#   policy     = try(each.value.policy, null)
#   tags       = each.value.tags
# }

# Security Groups Module Example
# module "security_groups" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/security_groups?ref=main"
##  for_each = local.security_groups --- Uncomment this, when you set the locals ---
#   
#   # Security Group Configuration
#   name        = each.value.name
#   description = each.value.description
#   vpc_id      = each.value.vpc_id
#   
#   # Rules Configuration
#   ingress_rules = each.value.ingress_rules
#   egress_rules  = each.value.egress_rules
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# IAM Policies Module Example
# module "iam_policies" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/iam_policies?ref=main"
##  for_each = local.iam_policies --- Uncomment this, when you set the locals ---
#   
#   # Policy Configuration
#   policy_name     = each.value.policy_name
#   description     = each.value.description
#   policy_document = each.value.policy_document
#   
#   # Attachments (optional)
#   attach_to_roles  = lookup(each.value, "attach_to_roles", [])
#   attach_to_users  = lookup(each.value, "attach_to_users", [])
#   attach_to_groups = lookup(each.value, "attach_to_groups", [])
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# IAM Roles Module Example
# module "iam_roles" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/iam_roles?ref=main"
##  for_each = local.iam_roles --- Uncomment this, when you set the locals ---
#   
#   # Role Configuration
#   role_name               = each.value.role_name
#   description            = each.value.description
#   assume_role_policy     = each.value.assume_role_policy
#   max_session_duration   = lookup(each.value, "max_session_duration", 3600)
#   create_instance_profile = lookup(each.value, "create_instance_profile", false)
#   
#   # Policies
#   aws_managed_policy_arns = lookup(each.value, "aws_managed_policy_arns", [])
#   custom_policy_arns     = lookup(each.value, "custom_policy_arns", [])
#   inline_policies        = lookup(each.value, "inline_policies", [])
#   
#   # Common Tags
#   common_tags = each.value.tags
# }