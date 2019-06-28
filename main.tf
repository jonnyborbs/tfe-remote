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
        vpc_security_group_ids  =       ["${var.sg_id}"]

        tags = {
            AppName = "TFE-Remote"
            CostCenter = "TFE-PM-001"
            AppOwner    =   "Jon"
        }
    }