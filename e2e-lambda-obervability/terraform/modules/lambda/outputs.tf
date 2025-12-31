output "lambda_function_arn" {
    value = aws_lambda_function.image_processor.arn
}

output "lambda_function_name" {
    value = aws_lambda_function.image_processor.function_name
}

output "log_group_name" {
    value = aws_cloudwatch_log_group.lambda_log_group.name
}
