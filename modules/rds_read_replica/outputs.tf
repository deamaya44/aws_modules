# Read Replica Outputs
output "read_replica_address" {
  description = "The RDS read replica hostname"
  value       = aws_db_instance.read_replica.address
}

output "read_replica_arn" {
  description = "The RDS read replica ARN"
  value       = aws_db_instance.read_replica.arn
}

output "read_replica_availability_zone" {
  description = "The availability zone of the read replica"
  value       = aws_db_instance.read_replica.availability_zone
}

output "read_replica_endpoint" {
  description = "The RDS read replica endpoint"
  value       = aws_db_instance.read_replica.endpoint
}

output "read_replica_hosted_zone_id" {
  description = "The canonical hosted zone ID of the read replica (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.read_replica.hosted_zone_id
}

output "read_replica_id" {
  description = "The RDS read replica ID"
  value       = aws_db_instance.read_replica.id
}

output "read_replica_resource_id" {
  description = "The RDS Resource ID of the read replica"
  value       = aws_db_instance.read_replica.resource_id
}

output "read_replica_status" {
  description = "The RDS read replica status"
  value       = aws_db_instance.read_replica.status
}

output "read_replica_port" {
  description = "The database port of the read replica"
  value       = aws_db_instance.read_replica.port
}

# DB Subnet Group Outputs
output "db_subnet_group_id" {
  description = "The db subnet group name for read replica"
  value       = var.create_subnet_group ? aws_db_subnet_group.read_replica[0].id : null
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group for read replica"
  value       = var.create_subnet_group ? aws_db_subnet_group.read_replica[0].arn : null
}