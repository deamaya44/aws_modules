variable "ami" {
  description = "The AMI to use for the instance."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
  type        = string
  default     = null
}

variable "nic" {
  description = "The primary network interface for the instance."
  type        = bool
  default     = false
}

variable "primary_network_interface" {
  description = "The primary network interface for the instance."
  type        = string
  default     = null
}

variable "cpu_options" {
  description = "The CPU options for the instance."
  type        = bool
  default     = false
}

variable "core_count" {
  description = "The ID of the instance."
  type        = string
  default     = null
}

variable "threads_per_core" {
  description = "The device index of the network interface attachment on the instance."
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to the instance."
  type        = map(string)
}
variable "iam_instance_profile" {
  description = "The IAM instance profile to attach to the instance."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance."
  type        = string
  default     = null
}
