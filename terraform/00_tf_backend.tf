module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}

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
    dynamodb_table = "terraform_aws_django_state"
  }
}