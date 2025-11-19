# VPC
resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support   = var.enable_dns_support

    tags = merge(
        var.common_tags,
        {
            Name = var.vpc_name
        }
    )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
    count  = var.create_igw ? 1 : 0
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-igw"
        }
    )
}

# Public Subnets
resource "aws_subnet" "public" {
    count                   = var.public_subnet_cidrs != null ? length(var.public_subnet_cidrs) : 0
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidrs[count.index]
    availability_zone       = var.availability_zones[count.index]
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-public-${count.index + 1}"
            Type = "Public"
        }
    )
}

# Private Subnets
resource "aws_subnet" "private" {
    count             = var.private_subnet_cidrs != null ? length(var.private_subnet_cidrs) : 0
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-private-${count.index + 1}"
            Type = "Private"
        }
    )
}

# NAT Gateways
resource "aws_eip" "nat" {
    count  = var.create_nat_gateway ? 1 : 0
    domain = "vpc"

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
        }
    )

    depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
    count         = var.create_nat_gateway && var.public_subnet_cidrs != null ? 1 : 0
    allocation_id = aws_eip.nat[0].id
    subnet_id     = aws_subnet.public[count.index].id

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-nat-${count.index + 1}"
        }
    )

    depends_on = [aws_internet_gateway.main]
}

# Route Tables
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main[0].id
    }

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-public-rt"
        }
    )
}

resource "aws_route_table" "private" {
    count  = var.create_nat_gateway ? length(var.private_subnet_cidrs) : 1
    vpc_id = aws_vpc.main.id

    dynamic "route" {
        for_each = var.create_nat_gateway ? [1] : []
        content {
            cidr_block     = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.main[0].id
        }
    }

    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-private-rt-${count.index + 1}"
        }
    )
}

# Route Table Associations
resource "aws_route_table_association" "public" {
    count          = var.public_subnet_cidrs != null ? length(var.public_subnet_cidrs) : 0
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    count          = length(var.private_subnet_cidrs)
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = var.create_nat_gateway ? aws_route_table.private[count.index].id : aws_route_table.private[0].id
}

#S3 Endpoint
# VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
    count  = var.create_s3_endpoint ? 1 : 0
    vpc_id       = aws_vpc.main.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
    
    tags = merge(
        var.common_tags,
        {
            Name = "${var.vpc_name}-s3-endpoint"
        }
    )
}

# Data source to get current region


# Associate S3 endpoint with route tables
resource "aws_vpc_endpoint_route_table_association" "private_s3" {
    count           = var.create_s3_endpoint ? length(var.private_subnet_cidrs) : 1
    route_table_id  = aws_route_table.private[count.index].id
    vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

# resource "aws_vpc_endpoint_route_table_association" "public_s3" {
#     route_table_id  = aws_route_table.public.id
#     vpc_endpoint_id = aws_vpc_endpoint.s3.id
# }
