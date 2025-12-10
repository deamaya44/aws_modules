variable "storage_credentials" {
  description = "Map of storage credentials to create in Databricks"
  type = map(object({
    name             = string
    aws_account_id   = string
    role_name        = string
    external_id      = string
    policy_document  = string
    description      = optional(string, "IAM role for Databricks external location")
    comment          = optional(string, "Managed by Terraform")
    owner            = optional(string)
    force_destroy    = optional(bool, false)
    read_only        = optional(bool, false)
    tags             = optional(map(string), {})
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
