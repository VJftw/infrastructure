terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.15.0"
    }

  }
}

provider "aws" {
  profile = var.name

  region = "us-east-1"
}

provider "aws" {
  alias = "target"

  profile = "vjp-logs"

  region = "us-east-1"
}

data "aws_caller_identity" "source" {
  provider = aws
}

data "aws_region" "source" {
  provider = aws
}

data "aws_caller_identity" "target" {
  provider = aws.target
}

data "aws_region" "target" {
  provider = aws.target
}
