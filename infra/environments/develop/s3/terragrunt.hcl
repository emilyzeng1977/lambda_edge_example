include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  parent_config = read_terragrunt_config(find_in_parent_folders())
}

terraform {
  source = "../../../modules/s3"
}

inputs = {
  project = local.root_config.inputs.project
  env = local.parent_config.inputs.env

  region      = "ap-southeast-2"
  bucket_name = "tomniu-1234"
  index_file  = "${get_terragrunt_dir()}/../../../../static/index.html"
}
