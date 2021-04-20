terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  env_prefix = terraform.workspace
}

# resource "aws_budgets_budget" "myBudgets" {
#   name              = "monthly-budget"
#   budget_type       = "COST"
#   limit_amount      = "5.0"
#   limit_unit        = "USD"
#   time_unit         = "MONTHLY"
#   time_period_start = "2021-04-18_00:01"
# }

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${local.env_prefix}-tf-vpc"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${local.env_prefix}-tf-igw"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${local.env_prefix}-tf-rt"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${local.env_prefix}-tf-sub"
  }
}

resource "aws_route_table_association" "b" {
  route_table_id = aws_route_table.my_rt.id
  subnet_id      = aws_subnet.my_subnet.id
}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.env_prefix}-tf-sg"
  }
}

resource "aws_instance" "my_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data = <<-EOF
          #!/bin/bash
          echo "Hello, World">> index.html
          nohup busybox httpd -f -p "8080"  &
          EOF
  tags = {
    Name = "${local.env_prefix}-tf-ec2"
  }
}
