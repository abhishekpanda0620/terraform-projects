variable "vpc_cidr" {
    type = string
    description = "VPC CIDR"
}

variable "vpc_name" {
    type = string
    description = "VPC Name"
}

variable "subnet_cidr" {
    type = string
    description = "Subnet CIDR"
}

variable "subnet_name" {
    type = string
    description = "Subnet Name"
}

variable "availability_zone" {
    type = string
    description = "Availability Zone"
}
