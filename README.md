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

### 3. [Serverless Image Processor](./serverless-lambda)
A modular serverless application for event-driven image processing using AWS S3 and Lambda.

**Features:**
*   **Modular Architecture**: Separated `modules/s3` and `modules/lambda` for maintainability.
*   **Event-Driven**: Lambda triggered automatically by S3 uploads.
*   **Custom Layers**: Automated Docker-based build script for Python Pillow dependencies.
*   **State Recovery**: Scripts included for reliable resource cleanup and state management.

---

*More projects to come.*
