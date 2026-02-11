# CodeCommit Repository
resource "aws_codecommit_repository" "this" {
  repository_name = var.repository_name
  description     = var.description
  default_branch  = var.default_branch

  tags = merge(
    var.common_tags,
    {
      Name = var.repository_name
    }
  )
}

# CodeCommit Trigger (optional)
resource "aws_codecommit_trigger" "this" {
  count           = var.create_trigger ? 1 : 0
  repository_name = aws_codecommit_repository.this.repository_name

  dynamic "trigger" {
    for_each = var.triggers
    content {
      name            = trigger.value.name
      destination_arn = trigger.value.destination_arn
      branches        = lookup(trigger.value, "branches", [])
      events          = trigger.value.events
    }
  }
}

# CodeCommit Approval Rule Template (optional)
resource "aws_codecommit_approval_rule_template" "this" {
  count       = var.create_approval_rule ? 1 : 0
  name        = "${var.repository_name}-approval-rule"
  description = var.approval_rule_description

  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = var.approval_rule_branches
    Statements = [
      {
        Type                    = "Approvers"
        NumberOfApprovalsNeeded = var.approval_rule_approvals_needed
        ApprovalPoolMembers     = var.approval_rule_members
      }
    ]
  })
}

# Associate Approval Rule Template with Repository
resource "aws_codecommit_approval_rule_template_association" "this" {
  count                       = var.create_approval_rule ? 1 : 0
  approval_rule_template_name = aws_codecommit_approval_rule_template.this[0].name
  repository_name             = aws_codecommit_repository.this.repository_name
}
