output "api_endpoint" {
  description = "API Gateway Endpoint"
  value       = module.apigateway.api_endpoint
}

output "dynamodb_table" {
  description = "DynamoDB Table Name"
  value       = module.dynamodb.table_name
}
