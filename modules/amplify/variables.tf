variable "app_name" {
  description = "Name of the Amplify app"
  type        = string
}

variable "repository_url" {
  description = "GitHub repository URL (e.g., https://github.com/user/repo)"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token for repository access"
  type        = string
  sensitive   = true
}

variable "branch_name" {
  description = "Git branch to deploy"
  type        = string
  default     = "main"
}

variable "enable_auto_build" {
  description = "Enable automatic builds on push"
  type        = bool
  default     = true
}

variable "build_spec" {
  description = "Custom build specification (YAML). If empty, uses default for React/Vite"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Environment variables for the build"
  type        = map(string)
  default     = {}
}

variable "custom_domain" {
  description = "Custom domain name (leave empty for default amplifyapp.com domain)"
  type        = string
  default     = ""
}

variable "subdomain_prefix" {
  description = "Subdomain prefix for custom domain"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
