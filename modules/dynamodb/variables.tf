variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "hash_key" {
  description = "Hash key attribute name"
  type        = string
}

variable "range_key" {
  description = "Range key attribute name"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attributes"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name            = string
    hash_key        = string
    range_key       = optional(string)
    projection_type = string
    read_capacity   = optional(number)
    write_capacity  = optional(number)
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary indexes"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = string
  }))
  default = []
}

variable "read_capacity" {
  description = "Read capacity units (for PROVISIONED mode)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units (for PROVISIONED mode)"
  type        = number
  default     = 5
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
