module "dynamodb" {
  source = "./modules/dynamodb"

  table_name = "${var.project_name}-table"
}

module "lambda" {
  source = "./modules/lambda"

  function_name = "${var.project_name}-function"
  table_name    = module.dynamodb.table_name
  table_arn     = module.dynamodb.table_arn
}

module "apigateway" {
  source = "./modules/apigateway"

  api_name             = "${var.project_name}-api"
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
}
