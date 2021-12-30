terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  alias               = "management"
  allowed_account_ids = ["400744676526"]

  region = "us-east-1"
}
