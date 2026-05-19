variable "name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting"
  type        = string
}

variable "force_delete" {
  description = "Force delete repository with images"
  type        = bool
}

variable "scan_on_push" {
  description = "Scan images on push"
  type        = bool
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
