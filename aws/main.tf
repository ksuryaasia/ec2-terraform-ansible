
provider "aws" {
  region                   = var.region
  shared_credentials_files = ["C:\\Users\\EHTESHAM\\.aws\\credentials"]
}



module "ec2-server" {
  source            = "D:\\Devops\\Infra-using-Terraform\\ec2-instance-creation-using-terraform\\modules\\aws"
  availability_zone = var.availability_zone

}

