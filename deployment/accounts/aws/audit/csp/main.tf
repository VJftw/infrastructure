provider "aws" {
  profile = var.name

  region = "us-east-1"
}

provider "aws" {
  alias = "logs"

  profile = "vjp-logs"

  region = "us-east-1"
}
