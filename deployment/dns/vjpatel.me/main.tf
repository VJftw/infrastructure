terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "management"

  profile = "vjp-management"
  region  = "us-east-1"
}

provider "aws" {
  alias = "dns"

  profile = "vjp-dns"
  region  = "eu-west-1"
}
