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

# RDS Module Example
# module "rds" {
#   source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/rds?ref=main"
##  for_each = local.rds_instances --- Uncomment this, when you set the locals ---
#   
#   # Basic Configuration
#   identifier     = each.value.identifier
#   engine         = each.value.engine
#   engine_version = each.value.engine_version
#   instance_class = each.value.instance_class
#   
#   # Database Configuration
#   db_name  = lookup(each.value, "db_name", null)
#   username = each.value.username
#   password = each.value.password
#   
#   # Storage Configuration
#   allocated_storage  = each.value.allocated_storage
#   storage_encrypted  = lookup(each.value, "storage_encrypted", true)
#   
#   # Network & Security
#   subnet_ids             = each.value.subnet_ids
#   vpc_security_group_ids = each.value.vpc_security_group_ids
#   
#   # Backup & Maintenance
#   backup_retention_period = lookup(each.value, "backup_retention_period", 7)
#   skip_final_snapshot    = lookup(each.value, "skip_final_snapshot", false)
#   
#   # High Availability
#   multi_az = lookup(each.value, "multi_az", false)
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# RDS Read Replica Module Example
# module "rds_read_replica" {
#   source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/rds_read_replica?ref=main"
##  for_each = local.rds_read_replicas --- Uncomment this, when you set the locals ---
#   
#   # Basic Configuration
#   identifier            = each.value.identifier
#   source_db_identifier  = each.value.source_db_identifier
#   instance_class       = each.value.instance_class
#   
#   # Network & Security
#   vpc_security_group_ids = each.value.vpc_security_group_ids
#   publicly_accessible    = lookup(each.value, "publicly_accessible", false)
#   
#   # Storage Configuration (REQUIRED for cross-region encrypted replicas)
#   storage_encrypted = lookup(each.value, "storage_encrypted", true)
#   kms_key_id       = lookup(each.value, "kms_key_id", null)  # Use data.aws_kms_key.rds_target_region.arn
#   
#   # Subnet Group Configuration (choose one option)
#   create_subnet_group        = lookup(each.value, "create_subnet_group", false)
#   subnet_group_name          = lookup(each.value, "subnet_group_name", null)
#   subnet_ids                 = lookup(each.value, "subnet_ids", [])
#   existing_subnet_group_name = lookup(each.value, "existing_subnet_group_name", null)
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# Secrets Manager Module Example
# module "secrets_manager" {
#   source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/secrets_manager?ref=main"
##  for_each = local.secrets --- Uncomment this, when you set the locals ---
#   
#   # Basic Configuration
#   secret_name = each.value.secret_name
#   description = each.value.description
#   
#   # Secret Content (choose one option)
#   secret_string    = lookup(each.value, "secret_string", null)
#   secret_key_value = lookup(each.value, "secret_key_value", null)
#   
#   # Random Password Generation (optional)
#   generate_random_password = lookup(each.value, "generate_random_password", false)
#   password_length         = lookup(each.value, "password_length", 32)
#   
#   # Security
#   kms_key_id = lookup(each.value, "kms_key_id", null)
#   
#   # Common Tags
#   common_tags = each.value.tags
# }

# EC2 Module Example
# module "ec2" {
#   source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/ec2?ref=main"
##  for_each = local.ec2_instances --- Uncomment this, when you set the locals ---
#   
#   # Basic Configuration
#   instance_name = each.value.instance_name
#   instance_type = each.value.instance_type
#   
#   # Network Configuration
#   subnet_id                    = each.value.subnet_id
#   vpc_security_group_ids      = each.value.vpc_security_group_ids
#   associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
#   
#   # SSH Access
#   create_key_pair   = lookup(each.value, "create_key_pair", false)
#   key_name         = lookup(each.value, "key_name", null)
#   public_key       = lookup(each.value, "public_key", null)
#   existing_key_name = lookup(each.value, "existing_key_name", null)
#   
#   # Storage Configuration
#   root_volume_size      = lookup(each.value, "root_volume_size", 8)
#   root_volume_type     = lookup(each.value, "root_volume_type", "gp3")
#   root_volume_encrypted = lookup(each.value, "root_volume_encrypted", true)
#   
#   # User Data
#   user_data = lookup(each.value, "user_data", null)
#   
#   # Monitoring
#   detailed_monitoring = lookup(each.value, "detailed_monitoring", false)
#   
#   # Common Tags
#   common_tags = each.value.tags
# }
## Nic example
# module "nic" {
#     source = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/nic?ref=main"
#     for_each = local.nic
#     description = each.value.description
#     subnet_id = each.value.subnet_id
#     private_ips = each.value.private_ips
#     security_groups = each.value.security_groups
#     attachment = each.value.attachment
#     instance_id = try(each.value.instance_id, null)
#     device_index = try(each.value.device_index, null)
#     tags = each.value.tags
# }