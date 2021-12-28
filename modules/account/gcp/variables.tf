variable "domain" {
  type = string
  description = ""
}

variable "project_id" {
  type = string
  description = ""
}

variable "project_name" {
  type = string
  description = ""
}

variable "billing_account_display_name" {
  type = string
  description = ""
  default = "My Billing Account"
}

variable "folder_display_name" {
  type = string
  description = ""
  default = "sandbox"
}
