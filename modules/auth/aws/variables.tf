variable "account_name" {
  type = string
}

variable "pull_request_role_name" {
  type = string
}

variable "branch_role_names" {
  type = map(string)
}

variable "role_name" {
  type = string
}
