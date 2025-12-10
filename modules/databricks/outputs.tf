# Workspace Outputs
output "workspace_id" {
  description = "Databricks workspace ID"
  value       = databricks_mws_workspaces.this.workspace_id
}

output "workspace_url" {
  description = "Databricks workspace URL"
  value       = databricks_mws_workspaces.this.workspace_url
}

output "workspace_name" {
  description = "Databricks workspace name"
  value       = databricks_mws_workspaces.this.workspace_name
}

output "deployment_name" {
  description = "Databricks deployment name"
  value       = databricks_mws_workspaces.this.deployment_name
}

# IAM Outputs (external)
output "cross_account_role_arn" {
  description = "ARN of the cross-account IAM role (passed as input)"
  value       = var.cross_account_role_arn
}

# Storage Outputs (external bucket)
output "root_bucket_name" {
  description = "Name of the root S3 bucket for DBFS (external)"
  value       = var.databricks_root_bucket_name
}

# Configuration IDs
output "credentials_id" {
  description = "Databricks credentials configuration ID"
  value       = databricks_mws_credentials.this.credentials_id
}

output "storage_configuration_id" {
  description = "Databricks storage configuration ID"
  value       = databricks_mws_storage_configurations.this.storage_configuration_id
}

output "network_id" {
  description = "Databricks network configuration ID (if using customer-managed VPC)"
  value       = var.vpc_id != null ? databricks_mws_networks.this[0].network_id : null
}

# Customer Managed Keys
output "customer_managed_key_id" {
  description = "Databricks customer managed key ID (if configured)"
  value       = var.customer_managed_key_id != null ? databricks_mws_customer_managed_keys.this[0].customer_managed_key_id : null
}

# Workspace Token
output "databricks_token" {
  description = "Databricks workspace token (sensitive)"
  value       = databricks_mws_workspaces.this.token[0].token_value
  sensitive   = true
}
