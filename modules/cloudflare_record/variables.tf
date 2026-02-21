variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "name" {
  description = "DNS record name"
  type        = string
}

variable "type" {
  description = "DNS record type"
  type        = string
}

variable "content" {
  description = "DNS record content"
  type        = string
}

variable "ttl" {
  description = "TTL for the record"
  type        = number
  default     = 1
}

variable "proxied" {
  description = "Whether the record is proxied through Cloudflare"
  type        = bool
  default     = false
}

variable "comment" {
  description = "Comment for the record"
  type        = string
  default     = ""
}
