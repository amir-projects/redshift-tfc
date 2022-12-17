terraform {
  cloud {
    organization = "bjitinc"
    hostname     = "app.terraform.io"
    workspaces {
      name = "redshift"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.0"
    }
  }
  required_version = "~> 1.3.4"
}
