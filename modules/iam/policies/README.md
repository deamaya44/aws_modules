# IAM Policies Module

Este módulo de Terraform permite crear y gestionar IAM Policies personalizadas en AWS de manera flexible y reutilizable.

## Características

- Creación de IAM Policies custom con documentos JSON
- Adjuntar automáticamente políticas a roles, usuarios y grupos
- Etiquetado automático y personalizable
- Configuración de path personalizado
- Gestión centralizada de políticas reutilizables

## Uso

### Configuración con locals y for_each (Recomendado)

```hcl
# Define IAM policies configuration in locals
locals {
  iam_policies = {
    s3_read_only = {
      policy_name = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3 buckets"
      policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::my-bucket",
              "arn:aws:s3:::my-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Environment = "production"
        Project     = "web-app"
      }
    }
  }
}

# IAM Policies Module with for_each
module "iam_policies" {
  source   = "./modules/iam_policies"
  for_each = local.iam_policies
  
  policy_name     = each.value.policy_name
  description     = each.value.description
  policy_document = each.value.policy_document
  common_tags     = each.value.tags
}
```

### Uso individual

```hcl
module "s3_policy" {
    source = "./modules/iam_policies"
    
    policy_name = "S3ReadOnlyPolicy"
    description = "Policy for read-only access to S3"
    
    policy_document = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = ["s3:GetObject", "s3:ListBucket"]
                Resource = ["arn:aws:s3:::my-bucket/*"]
            }
        ]
    })
    
    attach_to_roles = ["MyRole1", "MyRole2"]
    
    common_tags = {
        Environment = "production"
        Project     = "web-app"
    }
}
```

## Variables de entrada

| Variable | Descripción | Tipo | Valor por defecto | Requerido |
|----------|-------------|------|------------------|-----------|
| `policy_name` | Nombre de la IAM policy | `string` | - | Sí |
| `description` | Descripción de la IAM policy | `string` | `"IAM policy managed by Terraform"` | No |
| `policy_document` | Documento JSON de la política | `string` | - | Sí |
| `path` | Path de la IAM policy | `string` | `"/"` | No |
| `attach_to_roles` | Lista de nombres de roles para adjuntar | `list(string)` | `[]` | No |
| `attach_to_users` | Lista de nombres de usuarios para adjuntar | `list(string)` | `[]` | No |
| `attach_to_groups` | Lista de nombres de grupos para adjuntar | `list(string)` | `[]` | No |
| `common_tags` | Etiquetas comunes | `map(string)` | `{}` | No |

## Outputs

| Output | Descripción |
|--------|-------------|
| `policy_arn` | ARN de la IAM policy |
| `policy_name` | Nombre de la IAM policy |
| `policy_id` | ID de la IAM policy |
| `policy_path` | Path de la IAM policy |
| `policy_attachment_count` | Total de adjuntos realizados |
| `attached_roles` | Lista de roles a los que se adjuntó |
| `attached_users` | Lista de usuarios a los que se adjuntó |
| `attached_groups` | Lista de grupos a los que se adjuntó |

## Ejemplos de políticas comunes

### Política S3 Read-Only
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]
}
```

### Política CloudWatch Logs
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

### Política Secrets Manager
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "arn:aws:secretsmanager:*:*:secret:app/*"
    }
  ]
}
```

### Política RDS Connect
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": [
        "arn:aws:rds-db:region:account:dbuser:db-instance-id/username"
      ]
    }
  ]
}
```

## Uso con el módulo IAM Roles

```hcl
# Crear política
module "my_policy" {
  source          = "./modules/iam_policies"
  policy_name     = "MyCustomPolicy"
  policy_document = jsonencode({...})
}

# Crear role y adjuntar política
module "my_role" {
  source              = "./modules/iam_roles"
  role_name          = "MyRole"
  assume_role_policy = jsonencode({...})
  custom_policy_arns = [module.my_policy.policy_arn]
}
```

## Notas importantes

- Las políticas se pueden adjuntar a múltiples roles, usuarios y grupos
- El documento de política debe ser JSON válido
- Se recomienda usar `jsonencode()` para generar el JSON
- Las políticas custom tienen límites de tamaño (2KB para inline, 6KB para managed)
- Se pueden combinar con políticas AWS managed en los roles

## Ejemplos adicionales

Consulta el archivo `examples.tf` para ver más ejemplos de configuración del módulo.