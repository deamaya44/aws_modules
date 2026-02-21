resource "null_resource" "this" {
  triggers = var.triggers

  dynamic "provisioner" {
    for_each = var.local_exec
    content {
      local-exec {
        command     = provisioner.value.command
        working_dir = try(provisioner.value.working_dir, null)
        environment = try(provisioner.value.environment, null)
        interpreter = try(provisioner.value.interpreter, null)
      }
    }
  }

  dynamic "provisioner" {
    for_each = var.remote_exec
    content {
      remote-exec {
        inline = try(provisioner.value.inline, null)
        script = try(provisioner.value.script, null)
      }
    }
  }

  dynamic "provisioner" {
    for_each = var.file
    content {
      file {
        source      = provisioner.value.source
        destination = provisioner.value.destination
        content     = try(provisioner.value.content, null)
      }
    }
  }

  connection {
    type        = try(var.connection.type, null)
    host        = try(var.connection.host, null)
    user        = try(var.connection.user, null)
    password    = try(var.connection.password, null)
    private_key = try(var.connection.private_key, null)
    port        = try(var.connection.port, null)
  }
}
