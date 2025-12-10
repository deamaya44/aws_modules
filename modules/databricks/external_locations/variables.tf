variable "storage_credentials" {
  description = "Map of storage credentials to create in Databricks"
  type = map(object({
    name          = string
    iam_role_arn  = string
    comment       = optional(string, "Managed by Terraform")
    owner         = optional(string)
    force_destroy = optional(bool, false)
    read_only     = optional(bool, false)
  }))
  default = {}
}

variable "external_locations" {
  description = "Map of external locations to create in Databricks"
  type = map(object({
    name            = string
    url             = string
    credential_key  = string # Key reference to storage_credentials map
    comment         = optional(string, "Managed by Terraform")
    owner           = optional(string)
    force_destroy   = optional(bool, false)
    read_only       = optional(bool, false)
    skip_validation = optional(bool, false)
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })))
  }))
  default = {}
}
