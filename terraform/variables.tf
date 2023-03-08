variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west-1"
}

variable "region_replica" {
  description = "The AWS region replica to create resources in."
  default     = "us-east-1"
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
    us-west-1 = "ami-0bd3976c0dbacc605"
  }
}
variable "instance_type" {
  default = "t2.micro"
}
variable "docker_image_url_django" {
  description = "Docker image to run in the ECS cluster"
  default     = "174819378488.dkr.ecr.us-west-1.amazonaws.com/terraform_aws_django:latest"
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
variable "rds_db_name" {
  description = "RDS database name"
  default     = "mydb"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

# domain
# TODO: added certificate late
variable "certificate_arn" {
  description = "AWS Certificate Manager ARN for validated domain"
  default     = "arn:aws:acm:us-west-1:174819378488:certificate/51b066d0-488f-4a90-a3de-40c350711f07"
}

# nginx
variable "docker_image_url_nginx" {
  description = "Docker image to run in the ECS cluster"
  default     = "174819378488.dkr.ecr.us-west-1.amazonaws.com/nginx:latest"
}

# allowed host
variable "allowed_hosts" {
  description = "Domain name for allowed hosts"
  default     = ".thevizironline.com .amazonaws.com"
}
