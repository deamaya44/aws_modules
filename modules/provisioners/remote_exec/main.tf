resource "null_resource" "this" {
  triggers = var.triggers

  connection {
    type        = var.connection_type
    host        = var.host
    user        = var.user
    password    = var.password
    private_key = var.private_key
    port        = var.port
  }

  provisioner "remote-exec" {
    inline = var.inline
    script = var.script
  }
}
