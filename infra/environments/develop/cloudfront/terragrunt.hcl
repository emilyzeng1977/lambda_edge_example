include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/cloudfront"
}

dependency "lambda_edge" {
  config_path = "../lambda_edge"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  region                = "ap-southeast-2"
  lambda_function_arn   = dependency.lambda_edge.outputs.lambda_qualified_arn
  bucket_domain_name    = dependency.s3.outputs.bucket_regional_domain_name
}
