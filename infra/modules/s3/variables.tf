variable "region" {
  description = "AWS region to deploy resources into"
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