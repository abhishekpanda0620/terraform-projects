resource "aws_lambda_layer_version" "pillow_layer" {
    layer_name = "${var.project_name}-pillow-layer"
    filename = "${path.module}/../../pillow_layer.zip"
    description = "Pillow layer for Lambda function"
    compatible_runtimes = ["python3.13"]
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../lambda/lambda_function.py"
  output_path = "${path.module}/../../../lambda_function.zip"
}

resource "aws_lambda_function" "image_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.13"
  timeout          = 60
  memory_size      = 1024
  layers = [aws_lambda_layer_version.pillow_layer.arn]
  environment {
    variables = {
      PROCESSED_BUCKET = var.processed_bucket_id
      LOG_LEVEL        = "INFO"
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${var.lambda_function_name}"
    retention_in_days = 7
}

resource "aws_iam_role" "lambda_role" {
    name = "${var.lambda_function_name}-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "${var.lambda_function_name}-policy"
    role = aws_iam_role.lambda_role.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = ["s3:GetObject", "s3:GetObjectVersion"]
                Effect = "Allow"
                Resource = "${var.upload_bucket_arn}/*"
            },
            {
                Action = ["s3:PutObject", "s3:PutObjectAcl"]
                Effect = "Allow"
                Resource = "${var.processed_bucket_arn}/*"
            },
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Effect = "Allow"
                Resource = "arn:aws:logs:${var.aws_region}"
            }
        ]
    })
}
