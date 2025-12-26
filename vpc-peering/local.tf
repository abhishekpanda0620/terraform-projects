locals {
    primary_user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl enable nginx
    echo "Hello from Primary VPC ${var.primary_region}" > /var/www/html/index.html
    echo "Host name: $(hostname)" >> /var/www/html/index.html
    echo "Private IP: $(hostname -I)" >> /var/www/html/index.html
    EOF
    
    secondary_user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl enable nginx
    echo "Hello from Secondary VPC ${var.secondary_region}" > /var/www/html/index.html
    echo "Host name: $(hostname)" >> /var/www/html/index.html
    echo "Private IP: $(hostname -I)" >> /var/www/html/index.html
    EOF
}   