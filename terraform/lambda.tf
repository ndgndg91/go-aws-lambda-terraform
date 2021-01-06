resource "aws_iam_role" "go-api-test" {
  name = "LambdaRole_GoAPITest"  # 고유한 이름이어야 한다.

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

resource "aws_iam_role_policy_attachment" "go-api-test" {
  role       = aws_iam_role.go-api-test.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "go-api-test" {
  function_name = "go-api-test"
  role          = aws_iam_role.go-api-test.arn
  filename      = "../lambda.zip"  # 우선 로컬에 있는 파일을 직접 업로드한다.
  handler       = "main"
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 300
}

resource "aws_cloudwatch_log_group" "go-api-test" {
  name = "/aws/lambda/go-api-test"
}