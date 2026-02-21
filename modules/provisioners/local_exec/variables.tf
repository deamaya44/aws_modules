variable "triggers" {
  description = "Map of values that trigger recreation"
  type        = map(string)
  default     = {}
}

variable "command" {
  description = "Command to execute"
  type        = string
}

variable "working_dir" {
  description = "Working directory"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment variables"
  type        = map(string)
  default     = null
}

variable "interpreter" {
  description = "Command interpreter"
  type        = list(string)
  default     = null
}
