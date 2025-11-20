# Security Groups Module

Este módulo de Terraform permite crear y gestionar Security Groups en AWS de manera flexible y reutilizable.

## Características

- Creación de Security Groups con reglas personalizables
- Soporte para reglas de ingreso (ingress) y egreso (egress)
- Reglas pueden usar CIDR blocks o referencias a otros Security Groups
- Etiquetado automático y personalizable
- Configuración por defecto que permite todo el tráfico saliente

## Uso

### Configuración con locals y for_each (Recomendado)

```hcl
# Define security groups configuration in locals
locals {
  security_groups = {
    web = {
      name        = "web-server-sg"
      description = "Security group for web servers"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTP traffic"
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "HTTPS traffic"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Type        = "web-server"
      }
    }
    
    database = {
      name        = "database-sg"
      description = "Security group for database servers"
      ingress_rules = [
        {
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"]
          description = "MySQL access from private network"
        }
      ]
      tags = {
        Environment = "production"
        Project     = "web-app"
        Type        = "database"
      }
    }
  }
}

# Security Groups Module with for_each
module "security_groups" {
  source   = "./modules/security_groups"
  for_each = local.security_groups
  
  name          = each.value.name
  description   = each.value.description
  vpc_id        = var.vpc_id
  ingress_rules = each.value.ingress_rules
  common_tags   = each.value.tags
}
```

### Ejemplo básico (uso individual)

```hcl
module "web_security_group" {
    source = "./modules/security_groups"
    
    name        = "web-server-sg"
    description = "Security group for web servers"
    vpc_id      = "vpc-12345678"
    
    common_tags = {
        Environment = "production"
        Project     = "web-app"
    }
    
    ingress_rules = [
        {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
            description = "HTTP traffic"
        }
    ]
}
```

## Variables de entrada

| Variable | Descripción | Tipo | Valor por defecto | Requerido |
|----------|-------------|------|------------------|-----------|
| `name` | Nombre del Security Group | `string` | - | Sí |
| `description` | Descripción del Security Group | `string` | `"Security group managed by Terraform"` | No |
| `vpc_id` | ID del VPC donde crear el Security Group | `string` | - | Sí |
| `common_tags` | Etiquetas comunes para todos los recursos | `map(string)` | `{}` | No |
| `ingress_rules` | Lista de reglas de ingreso | `list(object)` | `[]` | No |
| `egress_rules` | Lista de reglas de egreso | `list(object)` | Regla por defecto que permite todo | No |
| `revoke_rules_on_delete` | Revocar todas las reglas al eliminar | `bool` | `true` | No |

### Estructura de las reglas

Cada regla en `ingress_rules` y `egress_rules` debe tener la siguiente estructura:

```hcl
{
    from_port                = number                # Puerto inicial
    to_port                  = number                # Puerto final
    protocol                 = string                # Protocolo (tcp, udp, icmp, -1 para todos)
    cidr_blocks             = list(string)           # Lista de bloques CIDR (opcional)
    source_security_group_id = string               # ID del Security Group origen (opcional, solo ingress)
    destination_security_group_id = string          # ID del Security Group destino (opcional, solo egress)
    description             = string                 # Descripción de la regla (opcional)
}
```

## Outputs

| Output | Descripción |
|--------|-------------|
| `security_group_id` | ID del Security Group creado |
| `security_group_arn` | ARN del Security Group |
| `security_group_name` | Nombre del Security Group |
| `security_group_description` | Descripción del Security Group |
| `security_group_vpc_id` | ID del VPC del Security Group |
| `security_group_owner_id` | ID del propietario del Security Group |
| `ingress_rules` | Lista de reglas de ingreso aplicadas |
| `egress_rules` | Lista de reglas de egreso aplicadas |

## Protocolos comunes

- `tcp` - TCP
- `udp` - UDP  
- `icmp` - ICMP
- `-1` - Todos los protocolos

## Puertos comunes

- `22` - SSH
- `80` - HTTP
- `443` - HTTPS
- `3306` - MySQL/MariaDB
- `5432` - PostgreSQL
- `6379` - Redis
- `27017` - MongoDB

## Notas importantes

- Las reglas de egreso por defecto permiten todo el tráfico saliente (`0.0.0.0/0`)
- Se puede usar `cidr_blocks` O `source_security_group_id` en las reglas, pero no ambos
- Los Security Groups son stateful: si permites tráfico entrante, la respuesta está automáticamente permitida

## Ejemplos adicionales

Consulta el archivo `examples.tf` para ver más ejemplos de uso del módulo.