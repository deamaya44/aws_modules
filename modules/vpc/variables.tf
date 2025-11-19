# VPC Configuration
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "vpc_name" {
    description = "Name for the VPC"
    type        = string
}

variable "enable_dns_hostnames" {
    description = "Enable DNS hostnames in the VPC"
    type        = bool
}

variable "enable_dns_support" {
    description = "Enable DNS support in the VPC"
    type        = bool
}

# Internet Gateway
variable "create_igw" {
    description = "Create Internet Gateway"
    type        = bool
}

# Subnets
variable "public_subnet_cidrs" {
    description = "List of CIDR blocks for public subnets"
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description = "List of CIDR blocks for private subnets"
    type        = list(string)
}

variable "availability_zones" {
    description = "List of availability zones"
    type        = list(string)
}

variable "map_public_ip_on_launch" {
    description = "Map public IP on launch for public subnets"
    type        = bool
}

# NAT Gateway
variable "create_nat_gateway" {
    description = "Create NAT Gateway"
    type        = bool
}
variable "create_s3_endpoint" {
    description = "Create S3 Private Endpoint"
    type        = bool
}

# Common Tags
variable "common_tags" {
    description = "Common tags to apply to all resources"
    type        = map(string)
}