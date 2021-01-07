resource "aws_api_gateway_rest_api" "gateway" {
  name = local.app_id
}

resource "aws_api_gateway_resource" "apis" {
  parent_id   = aws_api_gateway_rest_api.gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  path_part   = "apis"
}

resource "aws_api_gateway_resource" "passbooks" {
  parent_id   = aws_api_gateway_resource.apis.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  path_part   = "passbooks"
}

resource "aws_api_gateway_resource" "accounts" {
  parent_id   = aws_api_gateway_resource.passbooks.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  path_part   = "accounts"
}

resource "aws_api_gateway_resource" "my_info" {
  parent_id   = aws_api_gateway_resource.passbooks.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  path_part   = "my-info"
}

resource "aws_api_gateway_resource" "bank_accounts" {
  parent_id   = aws_api_gateway_resource.passbooks.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  path_part   = "bank-accounts"
}

resource "aws_api_gateway_method" "post_account" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.accounts.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_method" "delete_account" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.accounts.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_method" "get_my_info" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.my_info.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_method" "post_bank_accounts" {
  authorization = "NONE"
  http_method = "POST"
  resource_id = aws_api_gateway_resource.bank_accounts.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_method" "delete_bank_accounts" {
  authorization = "NONE"
  http_method = "DELETE"
  resource_id = aws_api_gateway_resource.bank_accounts.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_method" "get_bank_accounts" {
  authorization = "NONE"
  http_method = "GET"
  resource_id = aws_api_gateway_resource.bank_accounts.id
  rest_api_id = aws_api_gateway_rest_api.gateway.id
}

resource "aws_api_gateway_integration" "delete_accounts_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.accounts.id
  http_method             = aws_api_gateway_method.delete_account.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-delete-account.invoke_arn
}

resource "aws_api_gateway_integration" "delete_bank_accounts_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.bank_accounts.id
  http_method             = aws_api_gateway_method.delete_bank_accounts.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-delete-bank-account.invoke_arn
}

resource "aws_api_gateway_integration" "get_bank_accounts_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.bank_accounts.id
  http_method             = aws_api_gateway_method.get_bank_accounts.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-get-bank-account.invoke_arn
}

resource "aws_api_gateway_integration" "get_my_info_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.my_info.id
  http_method             = aws_api_gateway_method.get_my_info.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-get-my-info.invoke_arn
}

resource "aws_api_gateway_integration" "post_accounts_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.accounts.id
  http_method             = aws_api_gateway_method.post_account.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-post-account.invoke_arn
}

resource "aws_api_gateway_integration" "post_bank_accounts_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.bank_accounts.id
  http_method             = aws_api_gateway_method.post_bank_accounts.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.passbook-post-bank-account.invoke_arn
}



resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.delete_accounts_integration,
    aws_api_gateway_integration.delete_bank_accounts_integration,
    aws_api_gateway_integration.get_bank_accounts_integration,
    aws_api_gateway_integration.get_my_info_integration,
    aws_api_gateway_integration.post_accounts_integration,
    aws_api_gateway_integration.post_bank_accounts_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.gateway.id
  stage_name = "test"
}

resource "aws_lambda_permission" "lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.passbook-delete-account.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.api_deployment.execution_arn}/*/*"
}