variable "trusted_account_ids" {
  type = list(string)
  description = "The account IDs to trust assumption into the IAM roles created in this module."
}
