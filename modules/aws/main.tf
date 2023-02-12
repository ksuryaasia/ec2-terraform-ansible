locals {
  name      = "Test-server"
  Createdby = "Terraform"
}




data "aws_ami" "app_ami" {
  most_recent = true

  #owners = ["CentOS"]


  filter {
    name = "name"
    #values = ["amzn2-ami-hvm*"]       #reference -- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html , https://access.redhat.com/solutions/15356
    values = ["CentOS-7*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_vpc" "custom-vpc" {
  cidr_block = var.vpc

  tags = {
    "Name" = "Custom-VPC-using-terraform"
  }
}

resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-key.public_key_openssh
}


resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.custom-vpc.id
  cidr_block        = var.subnet
  availability_zone = var.availability_zone

  tags = {
    "Name" = "My-VPC-Using-Terraform"
  }

}

resource "aws_network_interface" "my-ec2-network-interface" {

  subnet_id = aws_subnet.mysubnet.id
  tags = {
    "Name" = "My-Custom-Network-Interface"
  }

}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.size
  key_name = var.key_name
  count = 1
   network_interface {
    network_interface_id = aws_network_interface.my-ec2-network-interface.id
    device_index         = 0
  }
  lifecycle {
     ignore_changes = [key_name]
     }

  tags = {
    Name      = local.name
    Createdby = local.Createdby
  }
}

