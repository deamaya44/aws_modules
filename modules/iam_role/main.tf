resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
  description        = var.description
  path               = var.path

  tags = var.common_tags
}
