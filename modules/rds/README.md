# RDS Module

This module creates an AWS RDS (Relational Database Service) instance with optional components like subnet groups, parameter groups, option groups, and read replicas.

## Features

- RDS instance with customizable configuration
- Optional DB subnet group creation
- Optional DB parameter group creation
- Optional DB option group creation
- Optional read replica creation
- Support for multiple database engines (MySQL, PostgreSQL, MariaDB, etc.)
- Comprehensive monitoring and backup configuration
- Security group integration
- Performance Insights support
- Multi-AZ deployment support

## Usage

### Basic MySQL Instance

```hcl
module "rds" {
  source = "./modules/rds"
  
  # Basic Configuration
  identifier     = "my-database"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  # Database Configuration
  db_name  = "myapp"
  username = "admin"
  password = "mypassword"
  
  # Network Configuration
  subnet_ids             = ["subnet-12345", "subnet-67890"]
  vpc_security_group_ids = ["sg-12345678"]
  
  # Storage Configuration
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = true
  
  # Tags
  common_tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Advanced Configuration with Custom Parameter Group

```hcl
module "rds_advanced" {
  source = "./modules/rds"
  
  # Basic Configuration
  identifier     = "advanced-database"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.r5.large"
  
  # Database Configuration
  db_name  = "production_db"
  username = "dbadmin"
  password = var.db_password
  
  # Network Configuration
  subnet_ids             = var.private_subnet_ids
  vpc_security_group_ids = [aws_security_group.rds.id]
  
  # Storage Configuration
  allocated_storage     = 100
  max_allocated_storage = 1000
  storage_type         = "gp3"
  storage_encrypted    = true
  
  # Parameter Group
  create_parameter_group  = true
  parameter_group_name   = "custom-mysql-params"
  parameter_group_family = "mysql8.0"
  parameters = [
    {
      name  = "innodb_buffer_pool_size"
      value = "{DBInstanceClassMemory*3/4}"
    },
    {
      name  = "max_connections"
      value = "200"
    }
  ]
  
  # Backup & Maintenance
  backup_retention_period = 14
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:06:00"
  
  # High Availability
  multi_az = true
  
  # Monitoring
  monitoring_interval                = 60
  monitoring_role_arn               = aws_iam_role.rds_monitoring.arn
  performance_insights_enabled      = true
  enabled_cloudwatch_logs_exports   = ["error", "general", "slow_query"]
  
  # Read Replica
  create_read_replica     = true
  replica_instance_class  = "db.r5.large"
  
  # Tags
  common_tags = local.common_tags
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identifier | The name of the RDS instance | `string` | n/a | yes |
| username | Username for the master DB user | `string` | n/a | yes |
| password | Password for the master DB user | `string` | n/a | yes |
| engine | The database engine | `string` | `"mysql"` | no |
| engine_version | The engine version to use | `string` | `"8.0"` | no |
| instance_class | The instance type of the RDS instance | `string` | `"db.t3.micro"` | no |
| allocated_storage | The allocated storage in gigabytes | `number` | `20` | no |
| subnet_ids | A list of VPC subnet IDs | `list(string)` | `[]` | no |
| vpc_security_group_ids | List of VPC security groups to associate | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_endpoint | The RDS instance endpoint |
| db_instance_address | The RDS instance hostname |
| db_instance_arn | The RDS instance ARN |
| db_instance_id | The RDS instance ID |
| db_instance_port | The database port |

## Supported Database Engines

- MySQL
- PostgreSQL
- MariaDB
- Oracle
- SQL Server
- Aurora MySQL
- Aurora PostgreSQL

## Security Considerations

1. Always use encrypted storage in production
2. Use strong passwords or AWS Secrets Manager
3. Restrict network access using security groups
4. Enable monitoring and logging
5. Regular backups and testing restore procedures

## Examples

See the `examples/` directory for complete examples of different RDS configurations.