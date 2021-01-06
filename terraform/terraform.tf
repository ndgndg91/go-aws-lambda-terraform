terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    bucket         = "go-api-test"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    acl            = "private"
  }
}

// data.tf
data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "go-api-test" {
  bucket = "go-api-test"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket" {
  value = data.aws_s3_bucket.go-api-test.bucket
}

// providers.tf
provider "aws" {
  region  = "ap-northeast-2"
}

output "api_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

variable "app_name" {
  description = "Application name"
  default     = "passbook-api"
}

variable "app_env" {
  description = "Application environment tag"
  default     = "dev"
}

resource "random_id" "unique_suffix" {
  byte_length = 2
}

locals {
  app_id = "${lower(var.app_name)}-${lower(var.app_env)}-${random_id.unique_suffix.hex}"
}