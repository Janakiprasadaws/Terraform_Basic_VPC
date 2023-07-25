# This Terraform Script deploys VPC,SUBNET,SECURITY GROUP and an new EC2 instance with Linux OS
# Author : Janakiprasad Anugula
# Date : 24-07-2023
# Referred using Terraform Registry
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  } 
  required_version = ">= 1.2.0"
}

provider "aws" {
   region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
   cidr_block = "${var.vpc_cidr}"
   enable_dns_hostnames = "true"
   
  tags = {
    Name = "${var.vpc_name}"
	Owner = "Janakiprasad Anugula"
  }
}
resource "aws_subnet" "Public_subnet1" {
   vpc_id = "${aws_vpc.default.id}"
   cidr_block = "${var.public_subnet_cidr}"
   availability_zone = "us-east-1a"
   
   tags = {
       Name = "Public_Subnet1"
	}
}
resource "aws_security_group" "Jenkins_security_group" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Jenkins_Server" {
   instance_type = "t2.micro"
   ami = "${var.image_name}"
   count = 1
   vpc_security_group_ids = ["${aws_security_group.Jenkins_security_group.id}"]
   subnet_id = "${aws_subnet.Public_subnet1.id}"
   key_name = "${var.key_name}"
   associate_public_ip_address = true	
    tags = {
	  Name = "Jenkins_Instance"
	}  
}
