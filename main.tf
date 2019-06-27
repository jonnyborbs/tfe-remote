terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "jschulman"

    workspaces {
      name = "tfe-remote"

    }
  }
}

provider "aws" {
    version = "~> 2.0"
}

resource "aws_security_group" "default" {
  name        = "TFAllowSSH"
  description = "Allow inbound SSH"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
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
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

    resource "aws_instance" "web" {
        ami                     =       "${data.aws_ami.ubuntu.id}"
        instance_type           =       "t2.micro"
        key_name                =       "${var.key_pair_name}"
        vpc_security_group_ids  =       ["${var.vpc_id}"]

        tags = {
            AppName = "TFE-Remote"
            AppOwner = "Jon"
            CostCenter = "TFE-PM-000"
        }
    }