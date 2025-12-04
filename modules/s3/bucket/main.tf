resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = var.policy
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}

# Ownership Controls - Required before ACL configuration
resource "aws_s3_bucket_ownership_controls" "this" {
  count  = var.acl_enabled ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  count      = var.acl_enabled ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

# Public Access Block (optional)
resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.block_public_access ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.replication_enabled ? 1 : 0
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.this]

  # role   = aws_iam_role.replication.arn
  role   = var.role_arn
  bucket = var.bucket_id

  rule {
    id = "replication-to-${regex("s3:::(.+)$", var.destination_bucket_arn)[0]}"

    # filter {
    #   prefix = "example"
    # }

    status = "Enabled"

    destination {
      bucket        = var.destination_bucket_arn
      storage_class = var.storage_class
    }
  }
}