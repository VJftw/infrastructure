terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

provider "aws" {
  alias = "website"

  profile = "vjp-website"
  region  = "us-east-1"
}
