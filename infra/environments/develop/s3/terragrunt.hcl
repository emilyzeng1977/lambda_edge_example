include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/s3"
}

inputs = {
  region      = "ap-southeast-2"
  bucket_name = "tomniu-1234"
  index_file  = "${get_terragrunt_dir()}/../../../../static/index.html"
}
