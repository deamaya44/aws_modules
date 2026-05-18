variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "addons" {
  description = "Map of EKS addons to install"
  type = map(object({
    version                  = optional(string)
    service_account_role_arn = optional(string)
  }))
}
