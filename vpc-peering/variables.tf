# N. Virginia region
variable "primary_region" {
    type = string
    description = "Primary region"
    default = "us-east-1"
}

# London region
variable "secondary_region" {
    type = string
    description = "Secondary region"
    default = "eu-west-2"
}

# Primary VPC CIDR
variable "primary_vpc_cidr" {
    type = string
    description = "Primary VPC CIDR"
    default = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
    type = string
    description = "Secondary VPC CIDR"
    default = "10.1.0.0/16"
}

variable "primary_key_name" {
    type = string
    description = "Primary key name"
    default = "vpc-peering-demo"
}

variable "secondary_key_name" {
    type = string
    description = "Secondary key name"
    default = "vpc-peering-demo-west"
}

variable "instance_type" {
    type = string
    description = "Instance type"
    default = "t2.micro"
}
    