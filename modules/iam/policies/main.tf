# IAM Policy
resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.description
  policy      = var.policy_document
  path        = var.path

  tags = merge(
    var.common_tags,
    {
      Name = var.policy_name
    }
  )
}

# Optional: Attach policy to roles
resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.attach_to_roles)
  role       = var.attach_to_roles[count.index]
  policy_arn = aws_iam_policy.this.arn
}

# Optional: Attach policy to users
resource "aws_iam_user_policy_attachment" "this" {
  count      = length(var.attach_to_users)
  user       = var.attach_to_users[count.index]
  policy_arn = aws_iam_policy.this.arn
}

# Optional: Attach policy to groups
resource "aws_iam_group_policy_attachment" "this" {
  count      = length(var.attach_to_groups)
  group      = var.attach_to_groups[count.index]
  policy_arn = aws_iam_policy.this.arn
}