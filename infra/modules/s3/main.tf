provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

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

  depends_on = [aws_s3_bucket_public_access_block.allow_public]
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.web_bucket.id
  key          = "static/index.html"
  source       = var.index_file
  content_type = "text/html"
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.web_bucket.bucket_regional_domain_name
}