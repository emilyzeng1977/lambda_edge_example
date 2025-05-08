provider "aws" {
  alias  = "edge"
  region = var.region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_edge_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "edgelambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = "${path.module}/../../scripts/lambda_edge_build.sh"
  }

  triggers = {
    requirements_hash = filesha256(var.requirements_file)
    code_hash         = filesha256(var.lambda_code_file)
  }
}

resource "aws_lambda_function" "edge_lambda" {
  provider         = aws.edge
  function_name    = "cloudfront-edge-hello"
  filename         = var.lambda_zip_path
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role.arn
  publish          = true
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  depends_on = [null_resource.zip_lambda]
}

output "lambda_qualified_arn" {
  value = aws_lambda_function.edge_lambda.qualified_arn
}
