variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the nodes"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the nodes"
  type        = list(string)
}

variable "instance_types" {
  description = "Instance types for the nodes"
  type        = list(string)
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
