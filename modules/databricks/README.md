# Databricks AWS Workspace Module

Este módulo de Terraform permite desplegar y gestionar workspaces de Databricks en AWS de manera completa y segura.

## Características

- Creación de Databricks Workspace con configuración completa
- Cross-account IAM Role con políticas necesarias
- S3 bucket para DBFS (Databricks File System)  
- Soporte para Customer-Managed VPC
- Configuración de Network, Storage y Credentials
- Soporte para Customer Managed Keys (CMK)
- Integración con Unity Catalog
- Configuración de seguridad según mejores prácticas

## Arquitectura

El módulo despliega los siguientes componentes:

### **IAM Resources**
- Cross-account IAM Role para Databricks
- IAM Policy con permisos EC2 necesarios
- Trust relationship con Databricks Account (414351767826)

### **Storage Resources**  
- S3 bucket para DBFS root storage
- Bucket policies con acceso controlado
- Block public access configuration

### **Databricks Resources**
- MWS Credentials configuration
- MWS Storage configuration  
- MWS Networks configuration (opcional)
- MWS Customer Managed Keys (opcional)
- Databricks Workspace

## Uso

### Configuración Básica

```hcl
module "databricks" {
  source = "./modules/databricks"
  
  # Required
  databricks_account_id       = "your-databricks-account-id"
  workspace_name             = "my-workspace"
  databricks_root_bucket_name = "my-databricks-root-bucket"
  
  # Optional
  deployment_name = "my-deployment"
  aws_region     = "us-east-1"
  
  common_tags = {
    Environment = "production"
    Project     = "analytics"
  }
}
```

### Configuración con Customer-Managed VPC

```hcl
module "databricks" {
  source = "./modules/databricks"
  
  databricks_account_id       = "your-databricks-account-id"
  workspace_name             = "my-workspace"
  databricks_root_bucket_name = "my-databricks-root-bucket"
  
  # VPC Configuration
  vpc_id             = "vpc-xxxxxxxxx"
  subnet_ids         = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
  security_group_ids = ["sg-xxxxxxxxx"]
  
  # Unity Catalog
  unity_catalog_bucket_name  = "my-unity-catalog-bucket"
  unity_catalog_iam_role_arn = "arn:aws:iam::123456789012:role/unity-catalog-role"
  
  common_tags = {
    Environment = "production"
    Project     = "analytics"
  }
}
```

### Configuración con Customer Managed Keys

```hcl
module "databricks" {
  source = "./modules/databricks"
  
  databricks_account_id       = "your-databricks-account-id"
  workspace_name             = "my-workspace"  
  databricks_root_bucket_name = "my-databricks-root-bucket"
  
  # Encryption
  customer_managed_key_id    = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  customer_managed_key_alias = "alias/databricks-cmk"
  
  common_tags = {
    Environment = "production"
    Project     = "analytics"
  }
}
```

## Variables

| Variable | Descripción | Tipo | Default | Requerido |
|----------|-------------|------|---------|-----------|
| `databricks_account_id` | Databricks Account ID | `string` | - | Sí |
| `workspace_name` | Nombre del workspace | `string` | - | Sí |
| `databricks_root_bucket_name` | Nombre del bucket S3 para DBFS | `string` | - | Sí |
| `deployment_name` | Nombre del deployment (único globalmente) | `string` | `null` | No |
| `aws_region` | Región de AWS | `string` | `"us-east-1"` | No |
| `vpc_id` | VPC ID para customer-managed VPC | `string` | `null` | No |
| `subnet_ids` | Lista de subnet IDs | `list(string)` | `[]` | No |
| `security_group_ids` | Lista de security group IDs | `list(string)` | `[]` | No |
| `customer_managed_key_id` | ARN de KMS key para encriptación | `string` | `null` | No |
| `unity_catalog_bucket_name` | Bucket para Unity Catalog | `string` | `null` | No |
| `unity_catalog_iam_role_arn` | IAM role para Unity Catalog | `string` | `null` | No |

## Outputs

| Output | Descripción |
|--------|-------------|
| `workspace_id` | ID del workspace de Databricks |
| `workspace_url` | URL del workspace de Databricks |
| `workspace_name` | Nombre del workspace |
| `cross_account_role_arn` | ARN del IAM role cross-account |
| `root_bucket_name` | Nombre del bucket S3 para DBFS |
| `databricks_token` | Token del workspace (sensitive) |

## Prerrequisitos

### Databricks Account
- Cuenta de Databricks con Account ID válido
- Acceso a Databricks Account Console

### AWS Permissions
El usuario/role de Terraform necesita permisos para:
- Crear y gestionar IAM roles y policies
- Crear y gestionar S3 buckets y policies
- Crear y gestionar recursos EC2 (si usa customer-managed VPC)
- Crear y gestionar KMS keys (si usa CMK)

### Databricks Provider
```hcl
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
  
  # Authentication via environment variables:
  # DATABRICKS_USERNAME / DATABRICKS_PASSWORD
  # or DATABRICKS_TOKEN
}
```

## Autenticación

### Variables de Entorno
```bash
export DATABRICKS_USERNAME="your-username"
export DATABRICKS_PASSWORD="your-password"

# O usando token
export DATABRICKS_TOKEN="your-token"
```

### OAuth (Recomendado para CI/CD)
```bash
export DATABRICKS_CLIENT_ID="your-client-id"
export DATABRICKS_CLIENT_SECRET="your-client-secret"
```

## Security Groups para Databricks

Si usas customer-managed VPC, los security groups deben permitir:

```hcl
# Ingress rules
- Port 443 (HTTPS) desde 0.0.0.0/0
- Port 2443 desde VPC CIDR  
- Ports 8443-8451 desde VPC CIDR

# Egress rules
- All traffic (0.0.0.0/0)
```

## Notas Importantes

1. **Deployment Name**: Debe ser único globalmente en Databricks
2. **S3 Bucket Names**: Deben ser únicos globalmente en AWS
3. **VPC Requirements**: Si especificas VPC, las subnets deben estar en al menos 2 AZs
4. **Security**: El módulo usa el Databricks Account oficial (414351767826)
5. **Tokens**: Los tokens generados son sensibles y deben manejarse apropiadamente

## Troubleshooting

### Error: Invalid Databricks Account ID
```
Solución: Verificar que el Account ID sea válido y esté activo
```

### Error: S3 Bucket Already Exists
```
Solución: Los nombres de bucket deben ser únicos globalmente
```

### Error: Network Configuration Invalid
```
Solución: Verificar que las subnets estén en diferentes AZs y sean privadas
```

## Ejemplos Avanzados

Ver el archivo `examples.tf` para configuraciones más complejas incluyendo:
- Integración con Unity Catalog
- Configuración multi-ambiente
- Customer Managed Keys
- Network isolation