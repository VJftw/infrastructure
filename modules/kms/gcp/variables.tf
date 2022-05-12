variable "name" {
  type = string
  description = "A unique name to a project which describes what the KMS key is used for"
}

variable "location" {
  type = string
  description = "The location to create the KMS encryption keys in"
}
