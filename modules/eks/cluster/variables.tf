variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the cluster"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public endpoint"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to access public endpoint"
  type        = list(string)
  default     = []
}

variable "authentication_mode" {
  description = "Authentication mode for the cluster (API, CONFIG_MAP, API_AND_CONFIG_MAP)"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}
