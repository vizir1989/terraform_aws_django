module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = "main"
  cidr                 = "172.18.0.0/16"
  azs                  = ["${var.region}a", "${var.region}b"]
  private_subnets      = ["172.18.64.0/20", "172.18.80.0/20",]
  public_subnets       = ["172.18.128.0/20", "172.18.144.0/20"]
  enable_dns_hostnames = true
}

module "nat" {
  source = "int128/nat-instance/aws"

  name                        = "main"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
  tags = {
    "Name" = "nat-instance-main"
  }
}

resource "aws_security_group_rule" "nat_ssh" {
  security_group_id = module.nat.sg_id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

## Production VPC
#resource "aws_vpc" "production-vpc" {
#  cidr_block           = "10.0.0.0/16"
#  enable_dns_support   = true
#  enable_dns_hostnames = true
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## Public subnets
#resource "aws_subnet" "public-subnet-1" {
#  cidr_block        = var.public_subnet_1_cidr
#  vpc_id            = aws_vpc.production-vpc.id
#  availability_zone = var.availability_zones[0]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
#resource "aws_subnet" "public-subnet-2" {
#  cidr_block        = var.public_subnet_2_cidr
#  vpc_id            = aws_vpc.production-vpc.id
#  availability_zone = var.availability_zones[1]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## Private subnets
#resource "aws_subnet" "private-subnet-1" {
#  cidr_block        = var.private_subnet_1_cidr
#  vpc_id            = aws_vpc.production-vpc.id
#  availability_zone = var.availability_zones[0]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
#resource "aws_subnet" "private-subnet-2" {
#  cidr_block        = var.private_subnet_2_cidr
#  vpc_id            = aws_vpc.production-vpc.id
#  availability_zone = var.availability_zones[1]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## Route tables for the subnets
#resource "aws_route_table" "public-route-table" {
#  vpc_id = aws_vpc.production-vpc.id
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
#resource "aws_route_table" "private-route-table" {
#  vpc_id = aws_vpc.production-vpc.id
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## Associate the newly created route tables to the subnets
#resource "aws_route_table_association" "public-route-1-association" {
#  route_table_id = aws_route_table.public-route-table.id
#  subnet_id      = aws_subnet.public-subnet-1.id
#}
#
#resource "aws_route_table_association" "public-route-2-association" {
#  route_table_id = aws_route_table.public-route-table.id
#  subnet_id      = aws_subnet.public-subnet-2.id
#}
#
#resource "aws_route_table_association" "private-route-1-association" {
#  route_table_id = aws_route_table.private-route-table.id
#  subnet_id      = aws_subnet.private-subnet-1.id
#}
#
#resource "aws_route_table_association" "private-route-2-association" {
#  route_table_id = aws_route_table.private-route-table.id
#  subnet_id      = aws_subnet.private-subnet-2.id
#}
#
## Elastic IP
#resource "aws_eip" "elastic-ip-for-nat-gw" {
#  vpc                       = true
#  associate_with_private_ip = "10.0.0.5"
#  depends_on                = [aws_internet_gateway.production-igw]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## NAT gateway
#resource "aws_nat_gateway" "nat-gw" {
#  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
#  subnet_id     = aws_subnet.public-subnet-1.id
#  depends_on    = [aws_eip.elastic-ip-for-nat-gw]
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
#resource "aws_route" "nat-gw-route" {
#  route_table_id         = aws_route_table.private-route-table.id
#  nat_gateway_id         = aws_nat_gateway.nat-gw.id
#  destination_cidr_block = "0.0.0.0/0"
#}
#
## Internet Gateway for the public subnet
#resource "aws_internet_gateway" "production-igw" {
#  vpc_id = aws_vpc.production-vpc.id
#  tags = {
#    "project" : var.project_name
#    "type" : terraform.workspace
#  }
#}
#
## Route the public subnet traffic through the Internet Gateway
#resource "aws_route" "public-internet-igw-route" {
#  route_table_id         = aws_route_table.public-route-table.id
#  gateway_id             = aws_internet_gateway.production-igw.id
#  destination_cidr_block = "0.0.0.0/0"
#}