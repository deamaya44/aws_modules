resource "aws_network_interface" "test" {
  subnet_id       = var.subnet_id
  private_ips     = var.private_ips
  security_groups = var.security_groups
  description     = var.description

  dynamic "attachment" {
    for_each = var.attachment ? [1] : []
    content {
      instance     = var.instance_id
      device_index = var.device_index
    }
  }

  tags = var.tags
}