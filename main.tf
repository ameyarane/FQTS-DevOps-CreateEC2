provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "jenkins_demo" {
  ami           = "ami-0ebfed9ccce07b642"
  instance_type = "t2.micro"
  key_name      =  "fqts-demo-key"
  vpc_security_group_ids = ["sg-0fc76108e42f52851"]
  tags = {
    Name = "jenkins-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

