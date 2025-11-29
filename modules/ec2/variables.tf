# Basic Configuration
variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instance (if null, uses latest Amazon Linux 2)"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Network Configuration
variable "subnet_id" {
  description = "ID of the subnet to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

# Key Pair Configuration
variable "create_key_pair" {
  description = "Whether to create a new key pair"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Name of the key pair to create or use"
  type        = string
  default     = null
}

variable "public_key" {
  description = "Public key material for creating new key pair"
  type        = string
  default     = null
}

variable "existing_key_name" {
  description = "Name of existing key pair to use"
  type        = string
  default     = null
}

# Storage Configuration
variable "root_volume_type" {
  description = "Type of root volume (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_delete_on_termination" {
  description = "Whether to delete root volume on instance termination"
  type        = bool
  default     = true
}

# Additional EBS Volumes
variable "ebs_block_devices" {
  description = "List of additional EBS block devices"
  type = list(object({
    device_name           = string
    volume_type           = string
    volume_size           = number
    encrypted             = bool
    delete_on_termination = bool
  }))
  default = []
}

# User Data
variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = null
}

# IAM
variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

# Monitoring
variable "detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

# Metadata Options
variable "metadata_http_endpoint" {
  description = "Whether the metadata service is available"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether metadata service requires session tokens"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "Desired HTTP PUT response hop limit for metadata requests"
  type        = number
  default     = 1
}

# Elastic IP
variable "create_eip" {
  description = "Whether to create and associate an Elastic IP"
  type        = bool
  default     = false
}

# Common Tags
variable "common_tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}