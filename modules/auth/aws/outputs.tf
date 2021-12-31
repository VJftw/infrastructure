output "role_arn" {
  value = "arn:aws:iam::${local.target_account_id}:role/${local.target_role}"
}
