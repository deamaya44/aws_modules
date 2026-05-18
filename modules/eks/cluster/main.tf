resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  access_config {
    authentication_mode = var.authentication_mode
  }

  lifecycle {
    ignore_changes = [access_config[0].bootstrap_cluster_creator_admin_permissions]
  }

  tags = var.common_tags
}
