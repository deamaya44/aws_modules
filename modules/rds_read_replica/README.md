# RDS Read Replica Module

This module creates an AWS RDS Read Replica from an existing RDS instance.

## Features

- Read replica creation from existing RDS instance
- Independent storage configuration
- Separate monitoring and backup settings
- Network and security configuration
- Cross-region read replica support

## Usage

### Basic Read Replica with New Subnet Group

```hcl
module "rds_read_replica" {
  source = "./modules/rds_read_replica"
  
  # Basic Configuration
  identifier            = "my-database-replica"
  source_db_identifier  = "my-database"
  instance_class       = "db.t3.micro"
  
  # Network Configuration
  vpc_security_group_ids = ["sg-12345678"]
  publicly_accessible    = false
  
  # Subnet Group (create new one)
  create_subnet_group = true
  subnet_group_name   = "my-database-replica-subnet-group"
  subnet_ids         = ["subnet-12345", "subnet-67890"]
  
  # Tags
  common_tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}
```

### Basic Read Replica with Existing Subnet Group

```hcl
module "rds_read_replica_existing" {
  source = "./modules/rds_read_replica"
  
  # Basic Configuration
  identifier            = "my-database-replica"
  source_db_identifier  = "my-database"
  instance_class       = "db.t3.micro"
  
  # Network Configuration
  vpc_security_group_ids = ["sg-12345678"]
  publicly_accessible    = false
  
  # Use existing subnet group
  create_subnet_group        = false
  existing_subnet_group_name = "existing-db-subnet-group"
  
  # Tags
  common_tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}
```

### Cross-Region Read Replica

```hcl
module "rds_cross_region_replica" {
  source = "./modules/rds_read_replica"
  
  # Different region provider
  providers = {
    aws = aws.us-west-2
  }
  
  # Basic Configuration
  identifier            = "my-database-west-replica"
  source_db_identifier  = "arn:aws:rds:us-east-1:123456789012:db:my-database"
  instance_class       = "db.r5.large"
  
  # Network Configuration
  vpc_security_group_ids = ["sg-87654321"]
  availability_zone     = "us-west-2a"
  
  # Storage Override
  storage_type      = "gp3"
  storage_encrypted = true
  
  # Monitoring
  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring_west.arn
  
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
| identifier | The name of the read replica instance | `string` | n/a | yes |
| source_db_identifier | The identifier of the source database | `string` | n/a | yes |
| instance_class | The instance type of the read replica | `string` | `"db.t3.micro"` | no |
| publicly_accessible | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| vpc_security_group_ids | List of VPC security groups to associate | `list(string)` | `[]` | no |
| create_subnet_group | Whether to create a DB subnet group | `bool` | `false` | no |
| subnet_group_name | Name of DB subnet group | `string` | `null` | no |
| subnet_ids | A list of VPC subnet IDs | `list(string)` | `[]` | no |
| existing_subnet_group_name | Name of existing DB subnet group to use | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| read_replica_endpoint | The RDS read replica endpoint |
| read_replica_address | The RDS read replica hostname |
| read_replica_arn | The RDS read replica ARN |
| read_replica_id | The RDS read replica ID |
| read_replica_port | The database port |

## Notes

- Read replicas inherit most settings from the source database
- Cross-region read replicas require the full ARN of the source database
- Storage encryption settings can be overridden for the read replica
- Read replicas can have different instance classes than the source database
- **IMPORTANT**: Read replicas require a DB subnet group. You can either:
  - Create a new one by setting `create_subnet_group = true` and providing `subnet_ids`
  - Use an existing one by setting `existing_subnet_group_name`
- If creating cross-region replicas, ensure the subnet group exists in the target region