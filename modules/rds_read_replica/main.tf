# DB Subnet Group (optional)
resource "aws_db_subnet_group" "read_replica" {
  count      = var.create_subnet_group ? 1 : 0
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = var.subnet_group_name
    }
  )
}

# RDS Read Replica
resource "aws_db_instance" "read_replica" {
  identifier                 = var.identifier
  replicate_source_db        = var.source_db_identifier
  instance_class            = var.instance_class
  publicly_accessible       = var.publicly_accessible
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  
  # Storage Configuration (optional overrides)
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted
  kms_key_id       = var.kms_key_id
  
  # Network & Security
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.create_subnet_group ? aws_db_subnet_group.read_replica[0].name : var.existing_subnet_group_name
  availability_zone     = var.availability_zone
  
  # Monitoring
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  
  # Backup Configuration
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  copy_tags_to_snapshot  = var.copy_tags_to_snapshot
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  
  # Maintenance
  maintenance_window = var.maintenance_window
  
  # Deletion Protection
  deletion_protection = var.deletion_protection

  tags = merge(
    var.common_tags,
    {
      Name = var.identifier
    }
  )
}