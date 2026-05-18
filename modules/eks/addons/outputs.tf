output "addon_names" {
  value = [for k, v in aws_eks_addon.this : v.addon_name]
}
