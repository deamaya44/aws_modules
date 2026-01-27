resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  dynamic "primary_network_interface" {
    for_each = var.nic ? [1] : []
    content {
      network_interface_id = var.primary_network_interface
    }
  }
  dynamic "cpu_options" {
    for_each = var.cpu_options ? [1] : []
    content {
      core_count       = var.core_count
      threads_per_core = var.threads_per_core
    }
  }

  iam_instance_profile = var.iam_instance_profile
  tags                 = var.tags
}