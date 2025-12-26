# Terraform Projects

This repository contains a collection of Terraform Infrastructure-as-Code (IaC) projects and examples.

## Projects

### 1. [Static Site Hosting](./static-site-hosting)
A complete module to host a static website on AWS using S3 and CloudFront with Origin Access Control (OAC).

**Features:**
*   Secure S3 bucket storage (no public access).
*   CloudFront CDN for global delivery and HTTPS.
*   Automated `Content-Type` detection for proper browser rendering.
*   Geo-restriction capabilities.

---

### 2. [VPC Peering](./vpc-peering)
A multi-region network setup demonstrating VPC Peering between `us-east-1` and `eu-west-2`.

**Features:**
*   Cross-region VPC Peering.
*   Automated Route Table configuration with explicit Peering Routes.
*   Security Group configuration for cross-VPC HTTP/ICMP access.
*   Multi-provider Terraform setup (Primary & Secondary regions).

---

*More projects to come.*
