terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_security_group" "this" {
    name = var.sg_name
    description = "Security group for ${var.instance_name}"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.ssh_ingress_cidr
    }

    ingress {
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = var.http_ingress_cidr
    }

    ingress {
        description = "Allow ICMP"
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = var.icmp_ingress_cidr
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_name
    }
}

resource "aws_instance" "this" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = var.key_name
    user_data = var.user_data
    tags = {
        Name = var.instance_name
    }
}
