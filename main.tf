terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "app_ami" {
  most_recent = true
  owners      = ["amazon"] # Change to the appropriate owner
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Modify based on the specific AMI you're looking for
  }
}


/*data "aws_ami" "app_ami" {
  most_recent      = true
  name_regex       = "cocktails-app-*"
  owners           = ["self"]
}*/

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "allow on port 8080"


  tags = {
    Name = "app_SG"
  }



  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



resource "aws_instance" "web_app" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]


  tags = {
    Name = "HelloWorld"
  }
}