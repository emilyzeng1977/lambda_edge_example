terraform {
  source = "../../../modules/lambda_edge"
}

inputs = {
  region                = "us-east-1"
  lambda_zip_path       = "${get_path_to_repo_root()}/packages/default_viewer_request_handler.zip"
  build_script_path     = "${get_path_to_repo_root()}/scripts/lambda_edge_build.sh"
  requirements_path     = "${get_path_to_repo_root()}/lambda/edge/requirements.txt"
  code_path             = "${get_path_to_repo_root()}/lambda/edge/default_viewer_request_handler.py"
}
