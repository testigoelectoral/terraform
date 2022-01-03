

resource "aws_lambda_function" "lambda" {
  function_name = "api-${local.function}-${var.environment}"

  role = aws_iam_role.role.arn

  s3_bucket        = local.artifacts_bucket
  s3_key           = "lambda/${local.function}/${local.function}.zip"
  source_code_hash = chomp(data.aws_s3_bucket_object.sha.body) # To forces deploy

  runtime = "go1.x"
  handler = "main"

}

data "aws_s3_bucket_object" "sha" {
  bucket = local.artifacts_bucket
  key    = "lambda/${local.function}/${local.function}.zip.sha256"
}

resource "aws_iam_role" "role" {
  name               = "lambda-${local.function}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-policy.json
}

data "aws_iam_policy_document" "lambda-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "policy" {
  name = "lambda-${local.function}-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${local.artifacts_bucket_arn}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach-basic_execution_role" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_alias" "running" {
  name             = "running"
  function_name    = aws_lambda_function.lambda.function_name
  function_version = "$LATEST"
}
