locals {
  region        = "ap-southeast-2"
  bucket        = "tfstate-emily"                # 远程 S3 桶
  dynamodb_table = "tfstate-lock-emily"          # DynamoDB 锁表
  project       = "book_store"  # 设置项目名为 book_store
  edge_region   = "us-east-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = local.dynamodb_table
  }
}

# 可选：生成默认 provider 配置供子模块使用
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  alias  = "default"
}

provider "aws" {
  region = "${local.edge_region}"
  alias  = "edge"
}
EOF
}
