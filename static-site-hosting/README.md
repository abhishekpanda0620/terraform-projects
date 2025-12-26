# Static Site Hosting with Terraform

This project provisions a secure, high-performance static website infrastructure on AWS using **Terraform**. It leverages S3 for storage and CloudFront for global content delivery, ensuring low latency and HTTPS security.

## 🏗 Architecture

- **AWS S3**: Stores your static web assets (HTML, CSS, JS, images).
- **Amazon CloudFront**: A Content Delivery Network (CDN) that caches your site globally and serves it over HTTPS.
- **Origin Access Control (OAC)**: Securely restricts access to the S3 bucket so it can *only* be accessed via CloudFront (direct public S3 access is blocked).

## 🚀 Usage

### Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed (v0.12+).
- AWS Credentials configured (e.g., via `aws configure` or environment variables).

### 1. Initialize
Download required providers and initialize the project:
```bash
terraform init
```

### 2. Configure (Optional)
The bucket name is set by default in `variables.tf`. You can override it by creating a `terraform.tfvars` file or passing a variable:
```bash
terraform apply -var="bucket_name=my-unique-bucket-name"
```
*Note: S3 bucket names must be globally unique.*

### 3. Deploy
Review and apply the plan:
```bash
terraform apply
```
Type `yes` to confirm.

### 4. Access Your Site
After deployment, Terraform will output the CloudFront URL:
```bash
static_site_hosting_url = "<cloudfront_url>"
```
Visit this URL in your browser to see your site.

## 📂 Project Structure

- **`app/`**: Put your website files (HTML, CSS, JS) here. Terraform automatically syncs this directory to the S3 bucket.
- **`main.tf`**: Defines the S3 bucket, CloudFront distribution, and IAM policies.
- **`variables.tf`**: Configuration variables.
- **`outputs.tf`**: Displays the site URL and bucket name after deployment.

## ⚙️ Key Features Implementation

- **Content-Type Automation**: The configuration automatically detects file extensions (`.html`, `.css`, `.js`, etc.) and sets the correct `Content-Type` header in S3, ensuring browsers render pages correctly instead of downloading them.
- **Security**: The S3 bucket blocks all public access. The IAM policy is explicitly scoped so only *your* specific CloudFront distribution can read the files.
- **Geo-Restriction**: Configured to whitelist specific locations (currently `IN`), ensuring content is only accessible from authorized geographic regions.

## 🧹 Cleanup
To destroy the infrastructure and stop incurring costs:
```bash
terraform destroy
```
*Note: You may need to manually empty the S3 bucket if versioning is enabled or if objects were created outside of Terraform.*
