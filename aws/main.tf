
provider "aws" {
  region = var.region
  shared_credentials_file = var.shared_credentials_file
}
/*
resource "aws_vpc" "custom-vpc" {
  cidr_block = var.vpc

  tags = {
    "Name" = "Custom-VPC-using-terraform"
  }
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
    "Name" = "My-Own-Network-Interface"
  }

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

resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-key.public_key_openssh
}

resource "aws_instance" "test-vm" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  count         = 1
  key_name      = aws_key_pair.generated_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.my-ec2-network-interface.id
    device_index         = 0
  }

  tags = {
    "Name" = "Test-VM-Using-Terraform"
  }


   connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }
  provisioner "file" {
    source      = "scripts/ansible-setup.sh"
    destination = "/root/script.sh"
  }

  provisioner "file" {
    source      = "playbooks/jenkins-setup.yaml"
    destination = "/root/jenkins-setup.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/script.sh",
      "/root/script.sh",
      "sudo ansible-playbook /root/jenkins-setup.yaml"
    ]
  }
}

output "private_key" {
  value     = tls_private_key.rsa-key.private_key_pem
  sensitive = true
}
*/