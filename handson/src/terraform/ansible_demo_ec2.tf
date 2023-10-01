
terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-southeast-2"
}

variable "key_name" {
  type = string
  default = "aws_sydney"
}


data "aws_ami" "ubuntu22" {
    most_recent = true
    owners = ["099720109477"] # Canonical
    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu*22.04*amd64*"]
    }    
}

data "aws_vpc" "default" {
  default = true
}

# Fetch the default security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}


resource "aws_instance" "example" {
    ami = data.aws_ami.ubuntu22.id
    
    instance_type = "t2.micro"
    key_name = var.key_name
  
    tags = {
        Name  = "example",
        Role = "node"       
      }
}

/*
resource "aws_instance" "jenkins" {
    for_each = toset(["jenkins-master", "jenkins-node1", "jenkins-node2"])
  
    ami = data.aws_ami.ubuntu22.id
    
    instance_type = "t2.micro"
    key_name = var.key_name #"${aws_key_pair.deployer.key_name}"
  
    tags = merge(
      {
        Name  = each.value            
      },
      length(regexall("jenkins", each.value)) > 0 ? { Project = "jenkins" } : {},
      length(regexall("master", each.value)) > 0 ? { Role = "master" } : {},
      length(regexall("node", each.value)) > 0 ? { Role = "node" } : {}  
    )
}
*/
resource "aws_security_group_rule" "allow_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = data.aws_security_group.default.id # var.default_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"s
  security_group_id = data.aws_security_group.default.id # var.default_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
}
