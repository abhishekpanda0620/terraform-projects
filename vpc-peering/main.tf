# Primary VPC Module
module "primary_vpc" {
    source = "./modules/vpc"
    providers = {
        aws = aws.primary
    }
    vpc_cidr = var.primary_vpc_cidr
    vpc_name = "primary-vpc-${var.primary_region}"
    subnet_cidr = var.primary_vpc_cidr
    subnet_name = "primary-subnet-${var.primary_region}"
    availability_zone = data.aws_availability_zones.primary.names[0]
}

# Secondary VPC Module
module "secondary_vpc" {
    source = "./modules/vpc"
    providers = {
        aws = aws.secondary
    }
    vpc_cidr = var.secondary_vpc_cidr
    vpc_name = "secondary-vpc-${var.secondary_region}"
    subnet_cidr = var.secondary_vpc_cidr
    subnet_name = "secondary-subnet-${var.secondary_region}"
    availability_zone = data.aws_availability_zones.secondary.names[0]
}

# VPC Peering
resource "aws_vpc_peering_connection" "vpc_peering_primary_to_secondary" {
    vpc_id = module.primary_vpc.vpc_id
    peer_vpc_id = module.secondary_vpc.vpc_id
    provider = aws.primary
    auto_accept = false
    peer_region = var.secondary_region
    tags = {
        Name = "vpc-peering-${var.primary_region}-${var.secondary_region}"
    }
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_secondary_to_primary" {
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_primary_to_secondary.id
    provider = aws.secondary
    auto_accept = true
    tags = {
        Name = "vpc-peering-${var.secondary_region}-${var.primary_region}"
    }
}

# AWS routes
resource "aws_route" "primary_route_to_secondary" {
    route_table_id = module.primary_vpc.route_table_id
    destination_cidr_block = module.secondary_vpc.vpc_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_primary_to_secondary.id
    provider = aws.primary
    depends_on = [aws_vpc_peering_connection.vpc_peering_primary_to_secondary]
}

resource "aws_route" "secondary_route_to_primary" {
    route_table_id = module.secondary_vpc.route_table_id
    destination_cidr_block = module.primary_vpc.vpc_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering_primary_to_secondary.id
    provider = aws.secondary
    depends_on = [aws_vpc_peering_connection_accepter.vpc_peering_secondary_to_primary]
}

# EC2 instances reference Compute Module
module "primary_compute" {
    source = "./modules/compute"
    providers = {
        aws = aws.primary
    }
    vpc_id = module.primary_vpc.vpc_id
    subnet_id = module.primary_vpc.subnet_id
    ami_id = data.aws_ami.primary_ami.id
    instance_type = var.instance_type
    key_name = var.primary_key_name
    sg_name = "primary-sg-${var.primary_region}"
    instance_name = "primary-instance-${var.primary_region}"
    ssh_ingress_cidr = ["0.0.0.0/0"]
    http_ingress_cidr = ["0.0.0.0/0"]
    icmp_ingress_cidr = ["0.0.0.0/0"]

    user_data = local.primary_user_data
}

module "secondary_compute" {
    source = "./modules/compute"
    providers = {
        aws = aws.secondary
    }
    vpc_id = module.secondary_vpc.vpc_id
    subnet_id = module.secondary_vpc.subnet_id
    ami_id = data.aws_ami.secondary_ami.id
    instance_type = var.instance_type
    key_name = var.secondary_key_name
    sg_name = "secondary-sg-${var.secondary_region}"
    instance_name = "secondary-instance-${var.secondary_region}"
    ssh_ingress_cidr = ["0.0.0.0/0"]
    http_ingress_cidr = [var.primary_vpc_cidr]
    icmp_ingress_cidr = [var.primary_vpc_cidr]
    user_data = local.secondary_user_data
}