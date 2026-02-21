# AWS Amplify Hosting Module

Módulo de Terraform para desplegar aplicaciones frontend con AWS Amplify Hosting.

## Características

- ✅ Integración directa con GitHub
- ✅ Auto-deploy en cada push
- ✅ Build automático (React, Vue, Angular, etc.)
- ✅ Dominio personalizado con SSL
- ✅ SPA routing (Single Page Application)
- ✅ Variables de entorno en build time
- ✅ Free Tier: 1000 build minutes/mes, 15 GB hosting

## Uso

```hcl
module "amplify_frontend" {
  source = "git::https://github.com/deamaya44/aws_modules.git//modules/amplify?ref=main"

  app_name       = "my-app"
  repository_url = "https://github.com/user/repo"
  github_token   = var.github_token
  branch_name    = "main"

  environment_variables = {
    VITE_API_URL = "https://api.example.com"
    NODE_ENV     = "production"
  }

  custom_domain     = "example.com"
  subdomain_prefix  = "app"

  common_tags = {
    Environment = "prod"
    Project     = "my-project"
  }
}
```

## Requisitos

1. **GitHub Personal Access Token** con permisos:
   - `repo` (acceso completo al repositorio)
   - Guardar en SSM Parameter Store o Secrets Manager

2. **Repositorio GitHub** con:
   - `package.json` con script `build`
   - Framework soportado (React, Vue, Angular, etc.)

## Variables

| Variable | Descripción | Tipo | Default | Requerido |
|----------|-------------|------|---------|-----------|
| `app_name` | Nombre de la app | string | - | Sí |
| `repository_url` | URL del repo GitHub | string | - | Sí |
| `github_token` | Token de acceso GitHub | string | - | Sí |
| `branch_name` | Rama a desplegar | string | `main` | No |
| `enable_auto_build` | Auto-build en push | bool | `true` | No |
| `build_spec` | Build spec personalizado | string | `""` | No |
| `environment_variables` | Variables de entorno | map(string) | `{}` | No |
| `custom_domain` | Dominio personalizado | string | `""` | No |
| `subdomain_prefix` | Prefijo del subdominio | string | `""` | No |
| `common_tags` | Tags comunes | map(string) | `{}` | No |

## Outputs

| Output | Descripción |
|--------|-------------|
| `app_id` | ID de la app Amplify |
| `app_arn` | ARN de la app |
| `default_domain` | Dominio por defecto (.amplifyapp.com) |
| `branch_url` | URL de la rama desplegada |
| `custom_domain` | URL del dominio personalizado |

## Build Spec por Defecto

Si no se especifica `build_spec`, usa:

```yaml
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - npm ci
    build:
      commands:
        - npm run build
  artifacts:
    baseDirectory: dist
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
```

## Ejemplo Completo

```hcl
# Obtener token de SSM
data "aws_ssm_parameter" "github_token" {
  name = "/github/token"
}

module "amplify_app" {
  source = "git::https://github.com/deamaya44/aws_modules.git//modules/amplify?ref=main"

  app_name       = "tasks-3d-prod"
  repository_url = "https://github.com/deamaya44/canicas-todo"
  github_token   = data.aws_ssm_parameter.github_token.value
  branch_name    = "main"

  environment_variables = {
    VITE_API_URL              = "https://api.example.com"
    VITE_FIREBASE_API_KEY     = var.firebase_api_key
    VITE_FIREBASE_PROJECT_ID  = var.firebase_project_id
  }

  custom_domain    = "amxops.com"
  subdomain_prefix = "app"

  common_tags = {
    Environment = "prod"
    Project     = "tasks-3d"
    Terraform   = "true"
  }
}

output "app_url" {
  value = module.amplify_app.branch_url
}
```

## Costos

**Free Tier (siempre):**
- 1000 build minutes/mes
- 15 GB almacenamiento
- 15 GB transferencia/mes
- Requests ilimitadas

**Después del Free Tier:**
- Build: $0.01/minuto
- Hosting: $0.15/GB transferencia
- Almacenamiento: $0.023/GB/mes

## Notas

- Amplify detecta automáticamente el framework (React, Vue, etc.)
- SSL/TLS incluido automáticamente
- CDN global incluido
- No requiere CloudFront ni S3 separados
