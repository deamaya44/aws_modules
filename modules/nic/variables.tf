variable "subnet_id" {
  description = "The subnet ID to create the network interface in."
  type        = string
}

variable "private_ips" {
  description = "List of private IP addresses to associate with the network interface."
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs to associate with the network interface."
  type        = list(string)
}

variable "attachment" {
  description = "Whether to attach the network interface to an instance."
  type        = bool
}

variable "instance_id" {
  description = "The ID of the instance to attach to."
  type        = string
  # default     = null
  nullable    = false
}

variable "device_index" {
  description = "The device index of the network interface attachment on the instance."
  type        = number
  # default     = null
  nullable    = false
}

variable "tags" {
  description = "Tags to apply to the network interface."
  type        = map(string)
}

variable "description" {
  description = "Description of the network interface."
  type        = string
  }