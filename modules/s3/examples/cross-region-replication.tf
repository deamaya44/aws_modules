# Ejemplo de Cross-Region Replication
# Proveedor para la región primaria (us-east-1)
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

# Proveedor para la región de réplica (us-west-2)
provider "aws" {
  alias  = "replica"
  region = "us-west-2"
}

# Bucket primario con CRR habilitado
module "primary_bucket" {
  source = "../"

  providers = {
    aws = aws.primary
  }

  name       = "my-primary-bucket-${random_id.bucket_suffix.hex}"
  versioning = true

  # Configuración de CRR
  enable_crr                    = true
  create_crr_role               = true
  crr_destination_bucket        = module.replica_bucket.bucket_arn
  crr_destination_storage_class = "STANDARD_IA"
  crr_prefix                    = "important/"
  crr_delete_marker_replication = true

  # Cifrado habilitado
  enable_server_side_encryption = true

  tags = {
    Environment = "production"
    Project     = "crr-example"
    Purpose     = "primary"
  }
}

# Bucket de réplica (debe crearse antes que la configuración CRR)
module "replica_bucket" {
  source = "../"

  providers = {
    aws = aws.replica
  }

  name       = "my-replica-bucket-${random_id.bucket_suffix.hex}"
  versioning = true

  # Cifrado habilitado
  enable_server_side_encryption = true

  tags = {
    Environment = "production"
    Project     = "crr-example"
    Purpose     = "replica"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Outputs
output "primary_bucket_name" {
  value = module.primary_bucket.bucket_name
}

output "replica_bucket_name" {
  value = module.replica_bucket.bucket_name
}

output "crr_role_arn" {
  value = module.primary_bucket.crr_role_arn
}