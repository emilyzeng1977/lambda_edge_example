# 引用项目根目录中的 root.hcl 配置（例如后端、provider 统一配置）
include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/lambda_edge"
}

locals {
  # 当前 terragrunt.hcl 文件的绝对路径
  # 例如，当路径为 /Users/tom/Study/Projects/lambda_edge_example/infra/environments/develop/lambda_edge/terragrunt.hcl 时，
  # get_terragrunt_dir() 的结果为：/Users/tom/Study/Projects/lambda_edge_example/infra/environments/develop/lambda_edge
  current_dir = get_terragrunt_dir()

  # 提取项目的根路径：通过相对路径向上跳转四级目录
  # 对于本示例，base_dir 的结果为：/Users/tom/Study/Projects/lambda_edge_example/
  base_dir = "${local.current_dir}/../../../../"
}

inputs = {
  # Lambda 的依赖 requirements.txt 路径
  lambda_requirements_file = "${local.base_dir}lambda/edge/requirements.txt"

  # Lambda 的主代码文件路径
  lambda_source_file = "${local.base_dir}lambda/edge/default_viewer_request_handler.py"

  # 构建的 Lambda zip 包路径
  lambda_package_path = "${local.base_dir}packages/"

  # 构建的 Lambda zip file
  lambda_package_file = "default_viewer_request_handler.zip"

  # 构建脚本的路径和文件名
  lambda_script_path = "${local.base_dir}scripts"
  lambda_script_file = "lambda_edge_build.sh"

  # Lambda 运行时相关配置
  handler = "default_viewer_request_handler.lambda_handler"
  runtime = "python3.10"
}
