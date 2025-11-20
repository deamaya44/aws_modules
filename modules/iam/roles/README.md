# IAM Roles Module

Este módulo de Terraform permite crear y gestionar IAM Roles en AWS de manera flexible y reutilizable.

## Características

- Creación de IAM Roles con políticas de confianza personalizables
- Soporte para políticas AWS managed, custom e inline
- Creación automática de Instance Profiles para EC2
- Configuración de permissions boundary
- Etiquetado automático y personalizable
- Configuración de duración máxima de sesión

## Uso

### Configuración con locals y for_each (Recomendado)

```hcl
# Define IAM roles configuration in locals
locals {
  iam_roles = {
    ec2_role = {
      role_name               = "EC2InstanceRole"
      description            = "IAM role for EC2 instances"
      create_instance_profile = true
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          }
        ]
      })
      aws_managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
      }
    }
  }
}

# IAM Roles Module with for_each
module "iam_roles" {
  source   = "./modules/iam_roles"
  for_each = local.iam_roles
  
  role_name               = each.value.role_name
  description            = each.value.description
  assume_role_policy     = each.value.assume_role_policy
  create_instance_profile = each.value.create_instance_profile
  aws_managed_policy_arns = each.value.aws_managed_policy_arns
  common_tags            = each.value.tags
}
```

## Variables de entrada

| Variable | Descripción | Tipo | Valor por defecto | Requerido |
|----------|-------------|------|------------------|-----------|
| `role_name` | Nombre del IAM role | `string` | - | Sí |
| `description` | Descripción del IAM role | `string` | `"IAM role managed by Terraform"` | No |
| `assume_role_policy` | Documento JSON de política de confianza | `string` | - | Sí |
| `path` | Path del IAM role | `string` | `"/"` | No |
| `max_session_duration` | Duración máxima de sesión en segundos | `number` | `3600` | No |
| `permissions_boundary_arn` | ARN del permissions boundary | `string` | `null` | No |
| `aws_managed_policy_arns` | Lista de ARNs de políticas AWS managed | `list(string)` | `[]` | No |
| `custom_policy_arns` | Lista de ARNs de políticas custom | `list(string)` | `[]` | No |
| `inline_policies` | Lista de políticas inline | `list(object)` | `[]` | No |
| `create_instance_profile` | Crear instance profile para EC2 | `bool` | `false` | No |
| `common_tags` | Etiquetas comunes | `map(string)` | `{}` | No |

### Estructura de inline_policies

```hcl
inline_policies = [
  {
    name   = "PolicyName"
    policy = jsonencode({...})  # JSON policy document
  }
]
```

## Outputs

| Output | Descripción |
|--------|-------------|
| `role_arn` | ARN del IAM role |
| `role_name` | Nombre del IAM role |
| `role_id` | ID del IAM role |
| `role_unique_id` | ID único del IAM role |
| `role_create_date` | Fecha de creación del role |
| `instance_profile_arn` | ARN del instance profile (si se creó) |
| `instance_profile_name` | Nombre del instance profile (si se creó) |
| `attached_aws_policies` | Lista de políticas AWS managed adjuntas |
| `attached_custom_policies` | Lista de políticas custom adjuntas |

## Ejemplos de uso común

### Role para EC2 con SSM
```hcl
assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }
  ]
})
aws_managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
create_instance_profile = true
```

### Role para Lambda
```hcl
assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }
  ]
})
aws_managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
```

### Role para Cross-Account Access
```hcl
assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::ACCOUNT-ID:root"
      }
      Condition = {
        StringEquals = {
          "sts:ExternalId" = "unique-external-id"
        }
      }
    }
  ]
})
```

## Notas importantes

- Los instance profiles solo se crean cuando `create_instance_profile = true`
- Las políticas inline se definen directamente en el role
- Se pueden combinar políticas AWS managed, custom e inline
- El permissions boundary es opcional y proporciona límites máximos de permisos

## Ejemplos adicionales

Consulta el archivo `examples.tf` para ver más ejemplos de configuración del módulo.