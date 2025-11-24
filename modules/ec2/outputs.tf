# EC2 Instance Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.this.public_dns
}

output "instance_private_dns" {
  description = "Private DNS name of the instance"
  value       = aws_instance.this.private_dns
}

output "security_groups" {
  description = "List of associated security groups"
  value       = aws_instance.this.security_groups
}

output "vpc_security_group_ids" {
  description = "List of associated security group IDs"
  value       = aws_instance.this.vpc_security_group_ids
}

# Key Pair Outputs
output "key_pair_name" {
  description = "The key pair name"
  value       = var.create_key_pair ? aws_key_pair.this[0].key_name : var.existing_key_name
}

output "key_pair_fingerprint" {
  description = "The MD5 public key fingerprint"
  value       = var.create_key_pair ? aws_key_pair.this[0].fingerprint : null
}

# Elastic IP Outputs
output "elastic_ip" {
  description = "The Elastic IP address"
  value       = var.create_eip ? aws_eip.this[0].public_ip : null
}

output "elastic_ip_association_id" {
  description = "The ID that represents the association of the Elastic IP address"
  value       = var.create_eip ? aws_eip.this[0].association_id : null
}

# Network Information
output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "subnet_id" {
  description = "The subnet ID of the instance"
  value       = aws_instance.this.subnet_id
}