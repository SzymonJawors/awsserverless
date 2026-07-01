provider "aws" {
  region = "eu-north-1"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "fastapi_lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "api" {
  filename = "api.zip"
  function_name = "fastapi-pro-app"
  role = aws_iam_role.lambda_exec.arn
  handler = "main.handler"
  runtime = "python3.13"
  source_code_hash = filebase64sha256("api.zip")
}

resource "aws_lambda_function_url" "api_url" {
  function_name = aws_lambda_function.api.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins = ["*"]
    allow_methods   = ["*"]
    allow_headers   = ["*"]
  }
}