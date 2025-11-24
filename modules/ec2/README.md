# AWS EC2 Instance Module

This module creates AWS EC2 instances with comprehensive configuration options including networking, storage, security, and monitoring.

## Features

- EC2 instance with latest Amazon Linux 2 AMI (or custom AMI)
- Optional SSH key pair creation or use existing ones
- Configurable root and additional EBS volumes
- Security group integration
- Optional Elastic IP allocation
- User data script support
- IAM instance profile support
- Enhanced metadata security (IMDSv2)
- Comprehensive monitoring options

## Usage

### Basic EC2 Instance

```hcl
module "ec2_web_server" {
  source = "./modules/ec2"
  
  # Basic Configuration
  instance_name  = "web-server-01"
  instance_type  = "t3.micro"
  
  # Network Configuration
  subnet_id                    = "subnet-12345678"
  vpc_security_group_ids      = ["sg-12345678"]
  associate_public_ip_address = true
  
  # SSH Access
  existing_key_name = "my-existing-keypair"
  
  # Tags
  common_tags = {
    Environment = "production"
    Project     = "web-app"
  }
}
```

### EC2 Instance with New Key Pair and User Data

```hcl
module "ec2_database_client" {
  source = "./modules/ec2"
  
  # Basic Configuration
  instance_name = "db-client-01"
  instance_type = "t3.small"
  
  # Network Configuration
  subnet_id                    = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.db_client.id]
  associate_public_ip_address = false
  
  # SSH Key Pair (create new)
  create_key_pair = true
  key_name       = "db-client-keypair"
  public_key     = file("~/.ssh/id_rsa.pub")
  
  # Storage Configuration
  root_volume_size      = 20
  root_volume_type     = "gp3"
  root_volume_encrypted = true
  
  # User Data for database client setup
  user_data = base64encode(templatefile("${path.module}/scripts/db-client-init.sh", {
    db_endpoint = var.database_endpoint
    db_name     = var.database_name
  }))
  
  # Additional EBS Volume
  ebs_block_devices = [
    {
      device_name           = "/dev/sdf"
      volume_type          = "gp3"
      volume_size          = 50
      encrypted            = true
      delete_on_termination = true
    }
  ]
  
  # Monitoring
  detailed_monitoring = true
  
  # Tags
  common_tags = local.common_tags
}
```

### Multi-Region EC2 Deployment

```hcl
# Primary Region (us-east-1)
module "ec2_primary" {
  source = "./modules/ec2"
  
  instance_name = "app-server-primary"
  instance_type = "t3.micro"
  
  subnet_id                    = var.primary_subnet_id
  vpc_security_group_ids      = [var.primary_security_group_id]
  associate_public_ip_address = true
  
  existing_key_name = var.primary_key_name
  
  user_data = base64encode(templatefile("scripts/app-init.sh", {
    region      = "us-east-1"
    db_endpoint = var.primary_db_endpoint
  }))
  
  common_tags = merge(local.common_tags, {
    Region = "primary"
  })
}

# Secondary Region (us-west-2)
module "ec2_secondary" {
  providers = {
    aws = aws.us-west-2
  }
  source = "./modules/ec2"
  
  instance_name = "app-server-secondary"
  instance_type = "t3.micro"
  
  subnet_id                    = var.secondary_subnet_id
  vpc_security_group_ids      = [var.secondary_security_group_id]
  associate_public_ip_address = true
  
  existing_key_name = var.secondary_key_name
  
  user_data = base64encode(templatefile("scripts/app-init.sh", {
    region      = "us-west-2"
    db_endpoint = var.secondary_db_endpoint
  }))
  
  common_tags = merge(local.common_tags, {
    Region = "secondary"
  })
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
| instance_name | Name for the EC2 instance | `string` | n/a | yes |
| subnet_id | ID of the subnet to launch instance in | `string` | n/a | yes |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| ami_id | AMI ID (if null, uses latest Amazon Linux 2) | `string` | `null` | no |
| vpc_security_group_ids | List of security group IDs | `list(string)` | `[]` | no |
| associate_public_ip_address | Associate a public IP address | `bool` | `false` | no |
| create_key_pair | Whether to create a new key pair | `bool` | `false` | no |
| existing_key_name | Name of existing key pair to use | `string` | `null` | no |
| user_data | User data script | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance |
| instance_public_ip | Public IP address of the instance |
| instance_private_ip | Private IP address of the instance |
| instance_public_dns | Public DNS name of the instance |
| instance_private_dns | Private DNS name of the instance |

## Security Best Practices

1. **Use IMDSv2**: Module enforces IMDSv2 by default
2. **Encrypt volumes**: Root volume encryption enabled by default
3. **Security Groups**: Always specify security groups for network access control
4. **Key Management**: Use AWS Systems Manager Session Manager instead of SSH when possible
5. **IAM Roles**: Use IAM instance profiles instead of hardcoded credentials
6. **Monitoring**: Enable detailed monitoring for production workloads

## User Data Examples

### Database Client Setup
```bash
#!/bin/bash
yum update -y
yum install -y postgresql

# Configure database connection
echo "export DB_HOST=${db_endpoint}" >> /etc/environment
echo "export DB_NAME=${db_name}" >> /etc/environment

# Install additional tools
yum install -y htop wget curl
```

### Web Server Setup
```bash
#!/bin/bash
yum update -y
yum install -y httpd

systemctl start httpd
systemctl enable httpd

echo "<h1>Web Server in ${region}</h1>" > /var/www/html/index.html
```