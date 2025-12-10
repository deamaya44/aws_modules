# IAM Roles Outputs
output "iam_roles" {
  description = "Map of IAM role details for storage credentials"
  value = {
    for k, v in aws_iam_role.storage_credential : k => {
      arn  = v.arn
      name = v.name
    }
  }
}

# Storage Credentials Outputs
output "storage_credentials" {
  description = "Map of storage credential IDs"
  value = {
    for k, v in databricks_storage_credential.this : k => {
      id       = v.id
      name     = v.name
      role_arn = v.aws_iam_role[0].role_arn
    }
  }
}

# External Locations Outputs
output "external_locations" {
  description = "Map of external location details"
  value = {
    for k, v in databricks_external_location.this : k => {
      id              = v.id
      name            = v.name
      url             = v.url
      credential_name = v.credential_name
    }
  }
}

# Individual outputs for easier reference
output "storage_credential_ids" {
  description = "Map of storage credential IDs (name => id)"
  value = {
    for k, v in databricks_storage_credential.this : v.name => v.id
  }
}

output "external_location_ids" {
  description = "Map of external location IDs (name => id)"
  value = {
    for k, v in databricks_external_location.this : v.name => v.id
  }
}
