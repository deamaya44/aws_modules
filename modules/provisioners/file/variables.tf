variable "triggers" {
  description = "Map of values that trigger recreation"
  type        = map(string)
  default     = {}
}

variable "source" {
  description = "Source file path"
  type        = string
  default     = null
}

variable "destination" {
  description = "Destination file path"
  type        = string
}

variable "content" {
  description = "File content"
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
