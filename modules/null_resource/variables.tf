variable "triggers" {
  description = "Map of values that trigger recreation"
  type        = map(string)
  default     = {}
}

variable "local_exec" {
  description = "List of local-exec provisioners"
  type = list(object({
    command     = string
    working_dir = optional(string)
    environment = optional(map(string))
    interpreter = optional(list(string))
  }))
  default = []
}

variable "remote_exec" {
  description = "List of remote-exec provisioners"
  type = list(object({
    inline = optional(list(string))
    script = optional(string)
  }))
  default = []
}

variable "file" {
  description = "List of file provisioners"
  type = list(object({
    source      = optional(string)
    destination = string
    content     = optional(string)
  }))
  default = []
}

variable "connection" {
  description = "Connection settings for remote provisioners"
  type = object({
    type        = optional(string)
    host        = optional(string)
    user        = optional(string)
    password    = optional(string)
    private_key = optional(string)
    port        = optional(number)
  })
  default = {}
}
