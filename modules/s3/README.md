# S3 Module

Este módulo de Terraform crea un bucket de S3 con funcionalidades avanzadas incluyendo Cross-Region Replication (CRR), cifrado, control de acceso público y configuración de lifecycle.

## Características

- ✅ Creación de bucket S3
- ✅ Control de versioning
- ✅ Cross-Region Replication (CRR)
- ✅ Cifrado del lado del servidor (SSE)
- ✅ Bloqueo de acceso público
- ✅ Configuración de lifecycle
- ✅ Políticas personalizadas
- ✅ Rol IAM automático para CRR

## Uso

### Ejemplo básico

```hcl
module "s3_bucket" {
  source = "./modules/s3"
  
  name       = "my-application-bucket"
  versioning = true
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}
```

### Ejemplo con Cross-Region Replication

```hcl
module "s3_primary_bucket" {
  source = "./modules/s3"
  
  name       = "my-app-primary-bucket"
  versioning = true
  
  # Habilitar CRR (requiere rol IAM creado externamente)
  enable_crr                     = true
  crr_role_arn                  = "arn:aws:iam::123456789012:role/my-crr-role"
  crr_destination_bucket        = "arn:aws:s3:::my-app-replica-bucket"
  crr_destination_storage_class = "STANDARD_IA"
  crr_prefix                    = "important/"
  crr_delete_marker_replication = true
  
  tags = {
    Environment = "production"
    Project     = "my-app"
  }
}

# Bucket de destino en otra región
module "s3_replica_bucket" {
  source = "./modules/s3"
  
  providers = {
    aws = aws.replica_region
  }
  
  name       = "my-app-replica-bucket"
  versioning = true
  
  tags = {
    Environment = "production"
    Project     = "my-app"
    Purpose     = "replica"
  }
}
```

### Ejemplo con cifrado KMS

```hcl
module "s3_encrypted_bucket" {
  source = "./modules/s3"
  
  name                        = "my-encrypted-bucket"
  versioning                  = true
  enable_server_side_encryption = true
  kms_key_id                  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  
  tags = {
    Environment = "production"
    Encrypted   = "true"
  }
}
```

### Ejemplo con reglas de lifecycle

```hcl
module "s3_lifecycle_bucket" {
  source = "./modules/s3"
  
  name       = "my-lifecycle-bucket"
  versioning = true
  
  lifecycle_rules = [
    {
      id      = "delete_old_versions"
      enabled = true
      
      noncurrent_version_expiration = {
        noncurrent_days = 30
      }
      
      abort_incomplete_multipart_upload_days = 7
    },
    {
      id      = "transition_to_ia"
      enabled = true
      
      transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
      
      filter = {
        prefix = "logs/"
      }
    }
  ]
  
  tags = {
    Environment = "production"
  }
}
```

## Variables

| Nombre | Descripción | Tipo | Por defecto | Requerido |
|--------|-------------|------|-------------|-----------|
| `name` | Nombre del bucket S3 | `string` | - | ✅ |
| `policy` | Documento JSON de política del bucket | `string` | `null` | ❌ |
| `versioning` | Habilitar versionado del bucket | `bool` | `false` | ❌ |
| `block_public_access` | Habilitar bloqueo de acceso público | `bool` | `false` | ❌ |
| `tags` | Tags a aplicar al bucket | `map(string)` | `{}` | ❌ |

### Variables de Cross-Region Replication

| Nombre | Descripción | Tipo | Por defecto | Requerido |
|--------|-------------|------|-------------|-----------|
| `enable_crr` | Habilitar Cross-Region Replication | `bool` | `false` | ❌ |
| `crr_role_arn` | ARN del rol IAM para CRR | `string` | `null` | ❌ |
| `crr_destination_bucket` | ARN del bucket de destino para CRR | `string` | `null` | ❌ |
| `crr_destination_storage_class` | Clase de almacenamiento para objetos replicados | `string` | `"STANDARD_IA"` | ❌ |
| `crr_prefix` | Prefijo de clave de objeto para la regla de replicación | `string` | `""` | ❌ |
| `crr_delete_marker_replication` | Replicar marcadores de eliminación | `bool` | `false` | ❌ |


### Variables de cifrado

| Nombre | Descripción | Tipo | Por defecto | Requerido |
|--------|-------------|------|-------------|-----------|
| `enable_server_side_encryption` | Habilitar cifrado del lado del servidor | `bool` | `true` | ❌ |
| `kms_key_id` | ID de clave KMS para cifrado | `string` | `null` | ❌ |

### Variables de lifecycle

| Nombre | Descripción | Tipo | Por defecto | Requerido |
|--------|-------------|------|-------------|-----------|
| `lifecycle_rules` | Lista de reglas de lifecycle | `list(object)` | `[]` | ❌ |

## Outputs

| Nombre | Descripción |
|--------|-------------|
| `bucket_id` | ID del bucket S3 |
| `bucket_arn` | ARN del bucket S3 |
| `bucket_name` | Nombre del bucket S3 |
| `bucket_domain_name` | Nombre de dominio del bucket S3 |
| `bucket_regional_domain_name` | Nombre de dominio regional del bucket S3 |
| `bucket_region` | Región del bucket S3 |
| `versioning_enabled` | Si el versionado está habilitado |
| `public_access_blocked` | Si el acceso público está bloqueado |
| `crr_enabled` | Si CRR está habilitado |
| `crr_role_arn` | ARN del rol IAM usado para CRR |
| `crr_destination_bucket` | Bucket de destino para CRR |
| `encryption_enabled` | Si el cifrado está habilitado |
| `kms_key_id` | ID de la clave KMS usada para cifrado |

## Requisitos

| Nombre | Versión |
|--------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Consideraciones importantes

1. **Cross-Region Replication**: Para usar CRR, el versionado debe estar habilitado tanto en el bucket origen como en el destino.

2. **Permisos IAM**: Debes crear el rol IAM para CRR externamente usando tu módulo IAM preferido y proporcionar el ARN en `crr_role_arn`.

3. **Regiones**: Para CRR, asegúrate de que el bucket de destino esté en una región diferente al bucket origen.

4. **Costos**: CRR y las transiciones de lifecycle pueden incurrir en costos adicionales. Revisa la documentación de precios de AWS S3.

5. **Cifrado**: Si no especificas `kms_key_id`, se usará AES256 (S3 Managed Keys) por defecto cuando el cifrado esté habilitado.

## Ejemplos adicionales

Ver el directorio `examples/` para más casos de uso detallados.