provider "aws" {
  region = "eu-west-1"
}

variable "environment" {
  description = "Environment name from pipeline"
  type        = string
}

# Create a security group in the correct VPC
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg-temp-${var.environment}"
  description = "Security group for Jenkins EC2"
  vpc_id      =  "vpc-020cdb293828a27e7"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all, restrict in prod!
  }
  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_demo" {
  ami                    = "ami-0ebfed9ccce07b642"
  instance_type          = "t2.micro"
  key_name               = "fqts-demo-key"
  #subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name        = "jenkins-${var.environment}"
    Environment = var.environment
  }
}


output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.jenkins_demo.public_ip
}
