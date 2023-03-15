variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-1"
}

variable "region_replica" {
  description = "The AWS region replica to create resources in."
  default     = "us-east-1"
}

# project_name
variable "project_name" {
  description = "Project name"

  validation {
    condition     = can(regex("^[a-zA-Z]+$", var.project_name))
    error_message = "You can use only alphabets symbols (a-zA-Z)"
  }
}

# tf backend
variable "tf_backend_bucket_name" {
  default = "terraform_aws_django_state"
}

variable "tf_backend_bucket_path" {
  default = "state/terraform.tfstate"
}

# networking
variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default     = "10.0.1.0/24"
}
variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
  default     = "10.0.2.0/24"
}
variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
  default     = "10.0.3.0/24"
}
variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]
}

# load balancer
variable "health_check_path" {
  description = "Health check path for the default target group"
  default     = "/ping/"
}

# ecs
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "production"
}
variable "amis" {
  description = "Which AMI to spawn."
  default = {
    us-west-1    = "ami-0bd3976c0dbacc605"
    us-west-2    = "ami-04e6179c63d17513d"
    us-east-1    = "ami-0fe19057e9cb4efd8"
    us-east-2    = "ami-086e001f1a73d208c"
    eu-central-1 = "ami-0e8f6957a4eb67446"
    eu-west-1    = "ami-02c55114d1d2a8201"
    eu-west-2    = "ami-02a7ca2a9d03676bf"
    eu-west-3    = "ami-0bce8e5f8fd912af2"
    eu-north-1   = "ami-0f541966b45340fce"
  }
}
variable "instance_type" {
  default = "t2.micro"
}
variable "docker_image_url_django" {
  description = "Docker image to run in the ECS cluster"
}
variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 2
}

# logs
variable "log_retention_in_days" {
  default = 30
}

# key pair
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/aws.pub"
}

# auto scaling
variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "1"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "10"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "4"
}

# rds
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

# domain
variable "certificate_arn" {
  description = "AWS Certificate Manager ARN for validated domain"
}

# nginx
variable "docker_image_url_nginx" {
  description = "Docker image to run in the ECS cluster"
}

# route53
variable "hosted_zone" {
  description = "Hosted zone"
}

# secret manager
variable "secret_id" {
  description = "Secret manager ID"
}
