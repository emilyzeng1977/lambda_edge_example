variable "region" {
  description = "Region for CloudFront (typically ap-southeast-2)"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the Lambda@Edge function"
  type        = string
}

variable "bucket_domain_name" {
  description = "Domain name of the S3 bucket origin"
  type        = string
}
