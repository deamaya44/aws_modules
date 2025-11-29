# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Key Pair (optional)
resource "aws_key_pair" "this" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = var.key_name
  public_key = var.public_key

  tags = merge(
    var.common_tags,
    {
      Name = var.key_name
    }
  )
}

# EC2 Instance
resource "aws_instance" "this" {
  ami                         = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.create_key_pair ? aws_key_pair.this[0].key_name : var.existing_key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  # Root block device
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = var.root_volume_encrypted
    delete_on_termination = var.root_volume_delete_on_termination
  }

  # Additional EBS volumes
  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices
    content {
      device_name           = ebs_block_device.value.device_name
      volume_type           = ebs_block_device.value.volume_type
      volume_size           = ebs_block_device.value.volume_size
      encrypted             = ebs_block_device.value.encrypted
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  # User data script
  user_data = var.user_data

  # IAM instance profile
  iam_instance_profile = var.iam_instance_profile

  # Monitoring
  monitoring = var.detailed_monitoring

  # Metadata options
  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.instance_name
    }
  )

  # Lifecycle
  lifecycle {
    ignore_changes = [ami]
  }
}

# Elastic IP (optional)
resource "aws_eip" "this" {
  count    = var.create_eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.instance_name}-eip"
    }
  )

  depends_on = [aws_instance.this]
}