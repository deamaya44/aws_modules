# Storage Credential for External Locations
resource "databricks_storage_credential" "this" {
  for_each = var.storage_credentials

  name = each.value.name
  aws_iam_role {
    role_arn = each.value.iam_role_arn
  }
  comment = lookup(each.value, "comment", "Managed by Terraform")

  # Optional: Add owner
  owner = lookup(each.value, "owner", null)

  # Optional: Force destroy
  force_destroy = lookup(each.value, "force_destroy", false)

  # Optional: Read-only mode
  read_only = lookup(each.value, "read_only", false)
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