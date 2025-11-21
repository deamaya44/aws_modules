# Databricks Credentials Configuration
resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = var.cross_account_role_arn
  credentials_name = "${var.workspace_name}-creds"
}

# Storage Configuration for Databricks
resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = var.databricks_root_bucket_name
  storage_configuration_name = "${var.workspace_name}-storage"
}

# Network Configuration (if VPC is provided)
resource "databricks_mws_networks" "this" {
  count = var.vpc_id != null ? 1 : 0
  
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace_name}-network"
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

# Customer Managed Keys (if provided)
resource "databricks_mws_customer_managed_keys" "this" {
  count = var.customer_managed_key_id != null ? 1 : 0
  
  provider   = databricks.mws
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn   = var.customer_managed_key_id
    key_alias = var.customer_managed_key_alias
  }
  use_cases = ["MANAGED_SERVICES"]
}

# Databricks Workspace
resource "databricks_mws_workspaces" "this" {
  provider       = databricks.mws
  account_id     = var.databricks_account_id
  workspace_name = var.workspace_name
  
  deployment_name = var.deployment_name
  aws_region      = var.aws_region
  
  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  
  # Network configuration (optional)
  network_id = var.vpc_id != null ? databricks_mws_networks.this[0].network_id : null
  
  # Customer managed keys (optional)
  managed_services_customer_managed_key_id = var.customer_managed_key_id != null ? databricks_mws_customer_managed_keys.this[0].customer_managed_key_id : null
  storage_customer_managed_key_id          = var.customer_managed_key_id != null ? databricks_mws_customer_managed_keys.this[0].customer_managed_key_id : null
  
  token {
    comment = "Terraform provisioned token"
  }
  
  depends_on = [
    databricks_mws_credentials.this,
    databricks_mws_storage_configurations.this
  ]
}

