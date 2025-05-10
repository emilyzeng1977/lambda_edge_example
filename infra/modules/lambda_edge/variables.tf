variable "lambda_package_file" {
  description = "Path to the packaged Lambda ZIP"
  type        = string
}

variable "lambda_script_path" {
  description = "Path to lambda_script_file"
  type        = string
}

variable "lambda_script_file" {
  description = "Path to lambda_script_file"
  type        = string
}

variable "lambda_requirements_file" {
  type = string
}

variable "lambda_source_file" {
  type = string
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
