# DB Subnet Group
resource "aws_db_subnet_group" "this" {
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

# DB Parameter Group
resource "aws_db_parameter_group" "this" {
  count  = var.create_parameter_group ? 1 : 0
  family = var.parameter_group_family
  name   = var.parameter_group_name

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.parameter_group_name
    }
  )
}



# RDS Instance
resource "aws_db_instance" "this" {
  # Basic Configuration
  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  # Storage Configuration
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id           = var.kms_key_id

  # Database Configuration
  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  # Network & Security
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.create_subnet_group ? aws_db_subnet_group.this[0].name : var.existing_subnet_group_name
  publicly_accessible    = var.publicly_accessible

  # Parameter Group
  parameter_group_name = var.create_parameter_group ? aws_db_parameter_group.this[0].name : var.existing_parameter_group_name

  # Backup & Maintenance
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window
  copy_tags_to_snapshot  = var.copy_tags_to_snapshot
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier

  # Monitoring
  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  # High Availability
  multi_az               = var.multi_az
  availability_zone     = var.availability_zone



  # Deletion Protection
  deletion_protection = var.deletion_protection

  # Auto Minor Version Upgrade
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  tags = merge(
    var.common_tags,
    {
      Name = var.identifier
    }
  )
}

