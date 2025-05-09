include {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../modules/lambda_edge"
}

inputs = {
  region                    = "us-east-1"
  lambda_requirements_file  = "${get_terragrunt_dir()}/../../../../lambda/edge/requirements.txt"
  lambda_source_file        = "${get_terragrunt_dir()}/../../../../lambda/edge/default_viewer_request_handler.py"
  lambda_package_file       = "${get_terragrunt_dir()}/../../../../packages/default_viewer_request_handler.zip"
  lambda_script_path        = "${get_terragrunt_dir()}/../../../../scripts"
  lambda_script_file        = "lambda_edge_build.sh"
  handler                   = "default_viewer_request_handler.lambda_handler"
  runtime                   = "python3.10"
}