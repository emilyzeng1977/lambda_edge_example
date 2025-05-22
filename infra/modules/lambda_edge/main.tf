terraform {
  backend "s3" {}
}

resource "aws_iam_role" "lambda_role" {
  provider         = aws.edge
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
  provider         = aws.edge
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = "cd ${var.lambda_script_path} && ./${var.lambda_script_file} ${var.lambda_package_path}"
  }

  triggers = {
    requirements_hash = filesha256(var.lambda_requirements_file)
    code_hash         = filesha256(var.lambda_source_file)
  }
}

resource "aws_lambda_function" "edge_lambda" {
  provider         = aws.edge
  function_name    = "cloudfront-lambda-edge-demo"
  filename         = "${var.lambda_package_path}${var.lambda_package_file}"
  handler          = var.handler
  runtime          = var.runtime
  role             = aws_iam_role.lambda_role.arn
  publish          = true
  source_code_hash = filebase64sha256(var.lambda_source_file)

  depends_on = [null_resource.zip_lambda]
}

output "lambda_qualified_arn" {
  value = aws_lambda_function.edge_lambda.qualified_arn
}
