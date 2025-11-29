# Ejemplo con reglas de lifecycle avanzadas
module "lifecycle_bucket" {
  source = "../"

  name       = "my-lifecycle-bucket-${random_id.bucket_suffix.hex}"
  versioning = true

  # Configuración de lifecycle
  lifecycle_rules = [
    {
      id      = "delete_old_versions"
      enabled = true

      # Eliminar versiones antiguas después de 30 días
      noncurrent_version_expiration = {
        noncurrent_days = 30
      }

      # Cancelar uploads multiparte incompletos después de 7 días
      abort_incomplete_multipart_upload_days = 7
    },
    {
      id      = "transition_logs"
      enabled = true

      # Transiciones para archivos de logs
      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
        {
          days          = 365
          storage_class = "DEEP_ARCHIVE"
        }
      ]

      # Aplicar solo a archivos con prefijo "logs/"
      filter = {
        prefix = "logs/"
      }
    },
    {
      id      = "expire_temporary_files"
      enabled = true

      # Eliminar archivos temporales después de 7 días
      expiration = {
        days = 7
      }

      # Aplicar solo a archivos con prefijo "temp/"
      filter = {
        prefix = "temp/"
      }
    }
  ]

  # Cifrado habilitado
  enable_server_side_encryption = true

  # Bloquear acceso público
  block_public_access = true

  tags = {
    Environment = "production"
    Project     = "lifecycle-example"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "lifecycle_bucket_name" {
  value = module.lifecycle_bucket.bucket_name
}