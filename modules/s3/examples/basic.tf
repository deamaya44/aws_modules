# Ejemplo básico de bucket S3
module "basic_s3_bucket" {
  source = "../"

  name       = "my-basic-bucket-${random_id.bucket_suffix.hex}"
  versioning = true

  block_public_access = true

  tags = {
    Environment = "development"
    Project     = "test-project"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

output "basic_bucket_name" {
  value = module.basic_s3_bucket.bucket_name
}