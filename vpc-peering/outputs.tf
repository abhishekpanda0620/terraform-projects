output "primary_vpc_id" {
    value = module.primary_vpc.vpc_id
}

output "secondary_vpc_id" {
    value = module.secondary_vpc.vpc_id
}

output "primary_compute_instance_public_ip" {
    value = module.primary_compute.public_ip
}

output "secondary_compute_instance_public_ip" {
    value = module.secondary_compute.public_ip
}

output "primary_compute_instance_private_ip" {
    value = module.primary_compute.private_ip
}

output "secondary_compute_instance_private_ip" {
    value = module.secondary_compute.private_ip
}


