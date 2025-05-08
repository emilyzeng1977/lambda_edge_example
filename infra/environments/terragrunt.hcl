locals {
  region_edge = "us-east-1"
  region_cdn  = "ap-southeast-2"
}

generate "provider_edge" {
  path      = "provider_edge.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_edge}"
  alias  = "edge"
}
EOF
}

generate "provider_cdn" {
  path      = "provider_cdn.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region_cdn}"
  alias  = "cdn"
}
EOF
}
