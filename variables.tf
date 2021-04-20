variable "region" {
  type        = string
  description = "the aws region"
}

variable "ami" {
  type        = string
  description = "the aws ami image id"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type e.g. t2.micro"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "subnet_cidr_block" {
  type        = string
  description = "subnet CIDR block"
}