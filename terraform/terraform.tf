terraform {
  required_version = ">= 0.12"
}

terraform {
  backend "s3" {
    bucket         = "passbook-api"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    acl            = "private"
  }
}

// data.tf
data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "passbook-api" {
  bucket = "passbook-api"
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "s3_bucket" {
  value = data.aws_s3_bucket.passbook-api.bucket
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

variable "passbook_delete_account_source_key" {
  description = "passbook delete account lambda function source object key"
  default = "passbook-delete-account/lambda.zip"
}

variable "passbook_delete_bank_account_source_key" {
  description = "passbook delete bank account lambda function source object key"
  default = "passbook-delete-bank-account/lambda.zip"
}

variable "passbook_get_bank_account_source_key" {
  description = "passbook get bank account lambda function source object key"
  default = "passbook-get-bank-account/lambda.zip"
}

variable "passbook_get_my_info_source_key" {
  description = "passbook get my info lambda function source object key"
  default = "passbook-get-my-info/lambda.zip"
}

variable "passbook_post_account_source_key" {
  description = "passbook post account lambda function source object key"
  default = "passbook-post-account/lambda.zip"
}

variable "passbook_post_bank_account_source_key" {
  description = "passbook post bank account lambda function source object key"
  default = "passbook-post-bank-account/lambda.zip"
}

resource "random_id" "unique_suffix" {
  byte_length = 2
}

locals {
  app_id = "${lower(var.app_name)}-${lower(var.app_env)}-${random_id.unique_suffix.hex}"
}