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

### 3. [End-to-End Observability](./e2e-lambda-obervability)
A serverless image processing pipeline with a production-grade observability stack.

**Features:**
*   **Full Observability**: CloudWatch Dashboards, Custom Metrics, and Alarms.
*   **Log Analytics**: Metric Filters extract structured data from unstructured logs.
*   **Alerting Pipeline**: SNS-based notifications for Critical, Performance, and Log-pattern events.
*   **Modular Design**: 6+ Terraform modules including `log_alerts` and `cloudwatch_metrics`.

---

*More projects to come.*
