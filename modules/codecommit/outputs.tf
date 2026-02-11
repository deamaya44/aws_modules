output "repository_id" {
  description = "The ID of the repository"
  value       = aws_codecommit_repository.this.repository_id
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_codecommit_repository.this.repository_name
}

output "arn" {
  description = "The ARN of the repository"
  value       = aws_codecommit_repository.this.arn
}

output "clone_url_http" {
  description = "The URL to use for cloning the repository over HTTPS"
  value       = aws_codecommit_repository.this.clone_url_http
}

output "clone_url_ssh" {
  description = "The URL to use for cloning the repository over SSH"
  value       = aws_codecommit_repository.this.clone_url_ssh
}

output "default_branch" {
  description = "The default branch of the repository"
  value       = aws_codecommit_repository.this.default_branch
}
