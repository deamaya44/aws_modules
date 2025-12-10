# Data source to get Unity Catalog assume role policy from Databricks
data "databricks_aws_unity_catalog_assume_role_policy" "this" {
  for_each = var.storage_credentials

  aws_account_id = each.value.aws_account_id
  role_name      = each.value.role_name
  external_id    = each.value.external_id
}

# IAM Role for Storage Credential
resource "aws_iam_role" "storage_credential" {
  for_each = var.storage_credentials

  name               = each.value.role_name
  assume_role_policy = data.databricks_aws_unity_catalog_assume_role_policy.this[each.key].json
  description        = lookup(each.value, "description", "IAM role for Databricks external location")
  
  tags = lookup(each.value, "tags", {})
}

# IAM Policy for S3 access
resource "aws_iam_role_policy" "storage_credential" {
  for_each = var.storage_credentials

  name   = "${each.value.role_name}-policy"
  role   = aws_iam_role.storage_credential[each.key].id
  policy = each.value.policy_document
}

# Storage Credential for External Locations
resource "databricks_storage_credential" "this" {
  for_each = var.storage_credentials

  name = each.value.name
  aws_iam_role {
    role_arn = aws_iam_role.storage_credential[each.key].arn
  }
  comment = lookup(each.value, "comment", "Managed by Terraform")

  # Optional: Add owner
  owner = lookup(each.value, "owner", null)

  # Optional: Force destroy
  force_destroy = lookup(each.value, "force_destroy", false)

  # Optional: Read-only mode
  read_only = lookup(each.value, "read_only", false)

  depends_on = [aws_iam_role_policy.storage_credential]
}

# External Locations pointing to S3 buckets/paths
resource "databricks_external_location" "this" {
  for_each = var.external_locations

  name            = each.value.name
  url             = each.value.url
  credential_name = databricks_storage_credential.this[each.value.credential_key].id
  comment         = lookup(each.value, "comment", "Managed by Terraform")

  # Optional: Add owner
  owner = lookup(each.value, "owner", null)

  # Optional: Force destroy
  force_destroy = lookup(each.value, "force_destroy", false)

  # Optional: Read-only mode
  read_only = lookup(each.value, "read_only", false)

  # Optional: Skip validation
  skip_validation = lookup(each.value, "skip_validation", false)

  depends_on = [databricks_storage_credential.this]
}

# Grants for External Locations
resource "databricks_grants" "external_location" {
  for_each = {
    for k, v in var.external_locations : k => v
    if lookup(v, "grants", null) != null
  }

  external_location = databricks_external_location.this[each.key].id

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }

  depends_on = [databricks_external_location.this]
}