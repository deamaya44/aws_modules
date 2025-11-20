variable "name" {
  type = string
}
variable "policy" {
  type = string
}
variable "versioning" {
  type    = bool
  default = false
}
variable "tags" {
  type = map(string)
}