resource "null_resource" "this" {
  triggers = var.triggers

  provisioner "local-exec" {
    command     = var.command
    working_dir = var.working_dir
    environment = var.environment
    interpreter = var.interpreter
  }
}
