# Serverless REST API with DynamoDB

This project demonstrates a serverless architecture using **AWS API Gateway (HTTP API)**, **AWS Lambda (Python)**, and **Amazon DynamoDB**, featuring **Safe Canary Deployments** using AWS CodeDeploy.

## Architecture

*   **API Gateway**: HTTP API exposing a public endpoint.
*   **Lambda**: Python 3.13 function handling CRUD operations.
*   **DynamoDB**: NoSQL database for storage.
*   **Modules**: Infrastructure is modularized into `dynamodb`, `lambda`, and `apigateway`.
*   **Canary Deployments**: Uses **AWS CodeDeploy** with a `Linear10PercentEvery5Minutes` strategy and Lambda Aliases (`live`).

## Deployment

1.  **Navigate to Terraform Directory:**
    ```bash
    cd terraform
    ```
2.  **Initialize:**
    ```bash
    terraform init
    ```
3.  **Deploy:**
    ```bash
    terraform apply
    ```
    Confirm the output `api_endpoint` URL.

## CRUD Endpoints

| Method | Path | Description | Example Body |
| :--- | :--- | :--- | :--- |
| `POST` | `/items` | Create Item | `{"id": "1", "name": "Apple"}` |
| `GET` | `/items/{id}` | Get Item | n/a |
| `GET` | `/items` | List Items | n/a |
| `DELETE` | `/items/{id}` | Delete Item | n/a |

## Canary Deployment & Verification

This project enables safe updates. When you update the Lambda code and verify via Terraform, CodeDeploy intercepts the change and shifts traffic gradually.

### How to Simulate a Canary Rollout
We have provided a helper script to automate the process (modifying code, publishing a new version, and monitoring traffic).

1.  **Run the script:**
    ```bash
    cd scripts
    ./simulate_canary.sh
    ```
2.  **Follow the prompts:**
    - Say **'y'** to publish a new version (this creates a timestamped update to `lambda/main.py`).
    - Say **'y'** to trigger the deployment.
3.  **Observe:**
    - The script will show real-time responses. You will see ~10% of requests hitting the new version initially.

## Project Structure

```
├── lambda/
│   └── main.py          # Python CRUD logic
├── terraform/
│   ├── modules/         # Reusable modules
│   ├── main.tf          # Root configuration
│   └── ...
└── scripts/
    └── simulate_canary.sh # Helper for testing deployments
```
