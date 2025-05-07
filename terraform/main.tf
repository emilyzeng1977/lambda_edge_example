provider "aws" {
  region = "us-east-1" # Lambda@Edge 要求部署在 us-east-1
  alias  = "edge"
}

provider "aws" {
  region = "ap-southeast-2"
  alias  = "cdn"
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

resource "aws_lambda_function" "edge_lambda" {
  provider         = aws.edge
  function_name    = "cloudfront-edge-hello"
  filename         = "${path.module}/../packages/default_viewer_request_handler.zip" # 请预先准备此文件
  handler          = "default_viewer_request_handler.lambda_handler"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_role.arn
  publish          = true
  source_code_hash = filebase64sha256("${path.module}/../packages/default_viewer_request_handler.zip")

  depends_on = [null_resource.zip_lambda]
}

resource "aws_cloudfront_distribution" "cdn" {
  provider            = aws.cdn
  enabled             = true
  default_root_object = "static/index.html"

  origin {
    domain_name = aws_s3_bucket.web_bucket.bucket_regional_domain_name
    origin_id   = "s3origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/static/*"
    target_origin_id = "s3origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # 没有 lambda_function_association，表示不使用 Lambda
  }

  default_cache_behavior {
    target_origin_id = "s3origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.edge_lambda.qualified_arn
      include_body = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = "${path.module}/../scripts/lambda_edge_build.sh"
  }

  triggers = {
    requirements_hash = filesha256("../lambda/edge/requirements.txt")
    code_hash         = filesha256("../lambda/edge/default_viewer_request_handler.py")
  }
}
