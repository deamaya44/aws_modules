variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "principal_arn" {
  description = "IAM principal ARN to grant access"
  type        = string
}

variable "kubernetes_groups" {
  description = "Kubernetes groups to associate"
  type        = list(string)
  default     = []
}

variable "policy_arn" {
  description = "EKS access policy ARN"
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

variable "access_scope_type" {
  description = "Access scope type (cluster or namespace)"
  type        = string
  default     = "cluster"
}
