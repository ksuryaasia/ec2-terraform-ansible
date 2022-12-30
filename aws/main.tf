terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"

    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "custom-vpc" {
  cidr_block = var.vpc
 
  tags = {
    "Name" = "Custom-VPC-using-terraform"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id = aws_vpc.custom-vpc.id
  cidr_block = var.subnet
  availability_zone = "us-west-2a"
  
   tags = {
     "Name" = "My-VPC-Using-Terraform"
   }

}

resource "aws_network_interface" "my-ec2-network-interface" {

    subnet_id = aws_subnet.mysubnet.id
  tags = {
    "Name" = "My-Own-Network-Interface"
  }

}

data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]       #reference -- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html
  }
}


resource "aws_instance" "test-vm" {
 ami = data.aws_ami.app_ami.id
 instance_type =  var.instance_type
 count = 1
 key_name = "ec2-key"   # Create the key pair and provide key
 
  network_interface {
    network_interface_id = aws_network_interface.my-ec2-network-interface.id
    device_index = 0
  } 

 tags = {
   "Name" = "Test-VM-Using-Terraform"
 }

}