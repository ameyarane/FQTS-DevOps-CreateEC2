provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "jenkins_demo" {
  ami           = "ami-0ebfed9ccce07b642"
  instance_type = var.instance_type
  tags = {
    Name = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

variable "instance_type" {
  default = "t2.micro"
}
