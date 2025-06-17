variable "project" {
  description = "Project name used for tagging and resource naming"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

variable "index_file" {
  description = "The path to the local index.html file to upload to S3"
  type        = string
}