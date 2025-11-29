# Lambda Module

This module creates an AWS Lambda function with optional VPC configuration, function URL, and CloudWatch logging.

## Features

- Lambda function creation
- VPC configuration support
- Function URL with CORS
- CloudWatch Log Group
- API Gateway permissions
- Dead letter queue support
- Lambda layers support

## Usage

```hcl
module "lambda" {
  source = "./modules/lambda"

  function_name = "my-lambda-function"
  role_arn      = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  
  filename = "lambda_function.zip"
  
  environment_variables = {
    DB_HOST = "my-database.us-east-1.rds.amazonaws.com"
    DB_NAME = "mydb"
  }
  
  # VPC Configuration
  subnet_ids         = ["subnet-12345", "subnet-67890"]
  security_group_ids = ["sg-12345"]
  
  # Function URL
  create_function_url = true
  function_url_cors = {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
  }
  
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}
```

## Variables

See `variables.tf` for all available variables.

## Outputs

See `outputs.tf` for all available outputs.
