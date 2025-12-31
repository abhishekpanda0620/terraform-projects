variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "table_arn" {
  description = "ARN of the DynamoDB table"
  type        = string
}
