variable "region" {
  description = "Region for Lambda@Edge (must be us-east-1)"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the packaged Lambda ZIP"
  type        = string
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime version"
  type        = string
  default     = "python3.10"
}

variable "requirements_file" {
  type = string
}

variable "lambda_code_file" {
  type = string
}
