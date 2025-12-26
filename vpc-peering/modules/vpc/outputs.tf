output "vpc_id" {
    value = aws_vpc.this.id
}

output "subnet_id" {
    value = aws_subnet.this.id
}

output "route_table_id" {
    value = aws_route_table.this.id
}

output "vpc_cidr_block" {
    value = aws_vpc.this.cidr_block
}
