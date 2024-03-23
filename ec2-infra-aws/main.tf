terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.49.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  # Configuration options
   region                   = var.region
  shared_credentials_files = ["/var/lib/jenkins/.aws/credentials"]
}


resource "aws_instance" "jenkins" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = "tf-key-pair-${random_id.server.hex}"
  depends_on = [
    aws_key_pair.tf-key-pair
  ]
 #vpc_security_group_ids = "[aws_security_group.dynamicsg-${random_id.server.hex}.id]"
  tags = {
    Name        = "Jenkins"
    Envrionment = "TST"
    Application = "SAP"
   
  }
}
resource "random_id" "server" {
  byte_length = 8
}
resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair-${random_id.server.hex}"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair-${random_id.server.hex}"
}


resource "local_file" "ansible_inventory" {
  
  content = templatefile("${path.module}/templates/inventory.tftpl",
     {
      ip = "${join("\n", ${aws_instance.*.private_ip})}"
    }

  )
 filename        = "${path.module}/playbooks/ansible_inventory.ini"
  file_permission = "0644"
  depends_on = [
    aws_instance.jenkins
  ]
}

output "server_private_ip" {
  value = aws_instance.jenkins.private_ip
}
output "server_public_ip" {
  value = aws_instance.jenkins.public_ip
}
