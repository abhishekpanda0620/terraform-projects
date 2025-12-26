# VPC Peering with Terraform

This project provisions two VPCs in different AWS regions (Peering) and establishes connectivity between them using VPC Peering. It demonstrates how to configure cross-region networking, Route Tables, and Security Groups to allow communication between EC2 instances in private networks.

## Architecture

*   **Primary Region**: `us-east-1` (N. Virginia)
    *   **VPC**: Primary VPC
    *   **Instance**: Ubuntu EC2 with Nginx
*   **Secondary Region**: `eu-west-2` (London)
    *   **VPC**: Secondary VPC
    *   **Instance**: Ubuntu EC2 with Nginx
*   **Connectivity**:
    *   AWS VPC Peering Connection (Requester/Accepter)
    *   Route Tables updated with Peering Routes
    *   Security Groups allowing cross-region HTTP (Port 80) and ICMP traffic

## Prerequisites

*   Terraform v1.0+
*   AWS Credentials configured
*   SSH Keys:
    *   `vpc-peering-demo.pem` (for Primary region)
    *   `vpc-peering-demo-west.pem` (for Secondary region)

## Usage

1.  **Initialize Terraform**:
    ```bash
    terraform init
    ```

2.  **Apply Configuration**:
    ```bash
    terraform apply
    ```
    *Review the plan and confirm with `yes`.*

3.  **Verify Outputs**:
    After a successful apply, Terraform will output the IPs:
    ```bash
    primary_compute_instance_public_ip    = "..."
    primary_compute_instance_private_ip   = "10.0.x.x"
    secondary_compute_instance_public_ip  = "..."
    secondary_compute_instance_private_ip = "10.1.x.x"
    ```

## Testing Connectivity

1.  **SSH into Primary Instance**:
    ```bash
    ssh -i "vpc-peering-demo.pem" ubuntu@<PRIMARY_PUBLIC_IP>
    ```

2.  **Test Peering Connection (IMPORTANT)**:
    Use the **Private IP** of the secondary instance to test peering. Public IPs traffic goes over the Internet and will be blocked.
    ```bash
    # Test HTTP (Nginx)
    curl http://<SECONDARY_PRIVATE_IP>

    # Test Ping
    ping <SECONDARY_PRIVATE_IP>
    ```

    You should see: `Hello from Secondary VPC eu-west-2`

## Cleanup

To destroy all resources:
```bash
terraform destroy
```
