output "invoke_arn" {
  description = "The Invoke ARN of the Lambda Alias"
  value       = aws_lambda_alias.live.invoke_arn
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}
