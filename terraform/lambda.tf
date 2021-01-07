resource "aws_iam_role" "passbook-api" {
  name = "LambdaRole_PassbookAPI"  # 고유한 이름이어야 한다.

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "passbook-api" {
  role       = aws_iam_role.passbook-api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "passbook_delete_account" {
  function_name = "passbook-delete-account"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_delete_account_source_key
  role          = aws_iam_role.passbook-api.arn
  handler       = "main"
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}

resource "aws_lambda_function" "passbook_delete_bank_account" {
  function_name = "passbook-delete-bank-account"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_delete_bank_account_source_key
  handler       = "main"
  role          = aws_iam_role.passbook-api.arn
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}

resource "aws_lambda_function" "passbook_get_bank_account" {
  function_name = "passbook-get-bank-account"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_get_bank_account_source_key
  handler       = "main"
  role          = aws_iam_role.passbook-api.arn
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}

resource "aws_lambda_function" "passbook_get_my_info" {
  function_name = "passbook-get-my-info"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_get_my_info_source_key
  handler       = "main"
  role          = aws_iam_role.passbook-api.arn
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}

resource "aws_lambda_function" "passbook_post_account" {
  function_name = "passbook-post-account"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_post_account_source_key
  handler       = "main"
  role          = aws_iam_role.passbook-api.arn
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}

resource "aws_lambda_function" "passbook_post_bank_account" {
  function_name = "passbook-post-bank-account"
  s3_bucket     = data.aws_s3_bucket.passbook-api.bucket
  s3_key        = var.passbook_post_bank_account_source_key
  handler       = "main"
  role          = aws_iam_role.passbook-api.arn
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 30
}