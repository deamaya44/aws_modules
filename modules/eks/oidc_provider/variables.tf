variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL from the EKS cluster"
  type        = string
}
