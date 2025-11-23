# Basic Configuration
variable "identifier" {
  description = "The name of the read replica instance"
  type        = string
}

variable "source_db_identifier" {
  description = "The identifier of the source database that this will be a read replica of"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the read replica"
  type        = string
  default     = "db.t3.micro"
}

# Network & Security
variable "publicly_accessible" {
  description = "Bool to control if read replica instance is publicly accessible"
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the read replica"
  type        = list(string)
  default     = []
}

variable "availability_zone" {
  description = "The AZ for the read replica"
  type        = string
  default     = null
}

# Subnet Group Configuration
variable "create_subnet_group" {
  description = "Whether to create a DB subnet group for the read replica"
  type        = bool
  default     = false
}

variable "subnet_group_name" {
  description = "Name of DB subnet group for the read replica"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for the read replica"
  type        = list(string)
  default     = []
}

variable "existing_subnet_group_name" {
  description = "Name of existing DB subnet group to use for the read replica"
  type        = string
  default     = null
}

# Storage Configuration
variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the read replica is encrypted"
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

# Monitoring
variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the read replica"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to Amazon CloudWatch Logs"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch for the read replica"
  type        = list(string)
  default     = []
}

# Backup Configuration
variable "backup_retention_period" {
  description = "The days to retain backups for the read replica"
  type        = number
  default     = null
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created for the read replica"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all read replica tags to the final snapshot"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the read replica is deleted"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this read replica is deleted"
  type        = string
  default     = null
}

# Maintenance
variable "maintenance_window" {
  description = "The window to perform maintenance in for the read replica"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the read replica during the maintenance window"
  type        = bool
  default     = true
}

# Other Settings
variable "deletion_protection" {
  description = "The read replica can't be deleted when this value is set to true"
  type        = bool
  default     = false
}

# Common Tags
variable "common_tags" {
  description = "A map of tags to assign to the read replica"
  type        = map(string)
  default     = {}
}