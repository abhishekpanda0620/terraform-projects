variable "vpc_id" {
    type = string
    description = "VPC ID"
}

variable "subnet_id" {
    type = string
    description = "Subnet ID"
}

variable "ami_id" {
    type = string
    description = "AMI ID"
}

variable "instance_type" {
    type = string
    description = "Instance Type"
}

variable "key_name" {
    type = string
    description = "Key Pair Name"
}

variable "sg_name" {
    type = string
    description = "Security Group Name"
}

variable "instance_name" {
    type = string
    description = "Instance Name tag"
}

variable "ssh_ingress_cidr" {
    type = list(string)
    description = "CIDR blocks allowed for SSH"
    default = ["0.0.0.0/0"]
}

variable "http_ingress_cidr" {
    type = list(string)
    description = "CIDR blocks allowed for HTTP"
    default = ["0.0.0.0/0"]
}

variable "icmp_ingress_cidr" {
    type = list(string)
    description = "CIDR blocks allowed for ICMP"
    default = ["0.0.0.0/0"]
}

variable "user_data" {
    type = string
    description = "User data script to run on instance launch"
    default = ""
}
