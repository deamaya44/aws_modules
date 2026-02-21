variable "triggers" {
  description = "Map of values that trigger recreation"
  type        = map(string)
  default     = {}
}

variable "inline" {
  description = "List of commands to execute"
  type        = list(string)
  default     = null
}

variable "script" {
  description = "Path to script file"
  type        = string
  default     = null
}

variable "connection_type" {
  description = "Connection type (ssh or winrm)"
  type        = string
  default     = "ssh"
}

variable "host" {
  description = "Host to connect to"
  type        = string
}

variable "user" {
  description = "User for connection"
  type        = string
}

variable "password" {
  description = "Password for connection"
  type        = string
  default     = null
  sensitive   = true
}

variable "private_key" {
  description = "Private key for SSH"
  type        = string
  default     = null
  sensitive   = true
}

variable "port" {
  description = "Port for connection"
  type        = number
  default     = null
}
