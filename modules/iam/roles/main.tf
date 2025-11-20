# IAM Role
resource "aws_iam_role" "this" {
    name                  = var.role_name
    description          = var.description
    assume_role_policy   = var.assume_role_policy
    path                 = var.path
    max_session_duration = var.max_session_duration
    
    permissions_boundary = var.permissions_boundary_arn
    
    dynamic "inline_policy" {
        for_each = var.inline_policies
        content {
            name   = inline_policy.value.name
            policy = inline_policy.value.policy
        }
    }

    tags = merge(
        var.common_tags,
        {
            Name = var.role_name
        }
    )
}

# Attach AWS managed policies to the role
resource "aws_iam_role_policy_attachment" "aws_managed" {
    count      = length(var.aws_managed_policy_arns)
    role       = aws_iam_role.this.name
    policy_arn = var.aws_managed_policy_arns[count.index]
}

# Attach custom policies to the role
resource "aws_iam_role_policy_attachment" "custom" {
    count      = length(var.custom_policy_arns)
    role       = aws_iam_role.this.name
    policy_arn = var.custom_policy_arns[count.index]
}

# Instance Profile (for EC2 instances)
resource "aws_iam_instance_profile" "this" {
    count = var.create_instance_profile ? 1 : 0
    name  = "${var.role_name}-profile"
    role  = aws_iam_role.this.name
    path  = var.path

    tags = merge(
        var.common_tags,
        {
            Name = "${var.role_name}-profile"
        }
    )
}