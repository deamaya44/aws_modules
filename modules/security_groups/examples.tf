########### Example usage of Security Groups module with locals and for_each ###########

# Define security groups configuration in locals
locals {
  security_groups = {
    web = {
      name        = "web-server-sg"
      description = "Security group for web servers"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTP traffic"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTPS traffic"
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "SSH access from private network"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "web-server"
      }
    }

    database = {
      name        = "database-sg"
      description = "Security group for database servers"
      ingress_rules = [
        {
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "MySQL access from private network"
        },
        {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "PostgreSQL access from private network"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "database"
      }
    }

    alb = {
      name        = "alb-sg"
      description = "Security group for Application Load Balancer"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTP traffic from internet"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTPS traffic from internet"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "load-balancer"
      }
    }

    cache = {
      name        = "cache-sg"
      description = "Security group for Redis/ElastiCache"
      ingress_rules = [
        {
          from_port   = 6379
          to_port     = 6379
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "Redis access from private network"
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Owner       = "devops-team"
        Type        = "cache"
      }
    }
  }
}

# Security Groups Module with for_each
# module "security_groups" {
#   source   = "git::ssh://git@github.com/deamaya44/aws_modules.git//modules/security_groups?ref=main"
#   for_each = local.security_groups
#   
#   # Security Group Configuration
#   name        = each.value.name
#   description = each.value.description
#   vpc_id      = var.vpc_id  # or module.vpc["main"].vpc_id
#   
#   # Rules Configuration
#   ingress_rules = each.value.ingress_rules
#   egress_rules  = each.value.egress_rules
#   
#   # Common Tags
#   common_tags = each.value.tags
# }