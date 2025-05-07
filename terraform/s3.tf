provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = "tomniu-1234"
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# 若使用 CloudFront + OAI，请确保 CloudFront 有权限访问
resource "aws_s3_bucket_policy" "web_policy" {
  bucket = aws_s3_bucket.web_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.web_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.web_bucket.id
  key          = "static/index.html"
  source       = "${path.module}/../static/index.html"
  content_type = "text/html"
}
