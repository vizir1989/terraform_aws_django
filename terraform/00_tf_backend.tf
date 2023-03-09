terraform {
  required_providers {
    aws = {
      version = "~> 4.57.0"
    }
    random = {
      version = "~> 3.4.3"
    }
    template = {
      version = "~> 2.2.0"
    }
  }

  backend "s3" {
    bucket         = "vizir-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "dynamodb-state-locking"
  }
}