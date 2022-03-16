resource "aws_lambda_function" "backend" {
  tags          = var.tags
  function_name = "${var.project}-function"

  s3_bucket        = aws_s3_object.function.bucket
  s3_key           = aws_s3_object.function.key
  source_code_hash = filebase64sha256(data.archive_file.function.output_path)

  handler = "index.handler"
  runtime = "nodejs14.x"

  role = aws_iam_role.function.arn # role to assume
}

resource "aws_iam_role" "function" {
  tags = var.tags
  name = "${var.project}-lamda-iam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "basic_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# attach execution role to role
resource "aws_iam_role_policy_attachment" "basic_execution_role_attachment" {
  policy_arn = data.aws_iam_policy.basic_execution_role.arn
  role       = aws_iam_role.function.name
}
