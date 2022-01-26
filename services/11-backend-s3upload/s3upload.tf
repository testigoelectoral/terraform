

resource "aws_lambda_function" "s3upload" {
  function_name = "backend-${local.function}-${var.environment}"

  role = aws_iam_role.s3upload.arn

  s3_bucket        = local.artifacts_bucket
  s3_key           = "back-end/lambda/${local.function}/${local.function}.zip"
  source_code_hash = chomp(data.aws_s3_bucket_object.s3upload.body) # To forces deploy

  runtime = "go1.x"
  handler = "main"
  publish = true

}

data "aws_s3_bucket_object" "s3upload" {
  bucket = local.artifacts_bucket
  key    = "back-end/lambda/${local.function}/${local.function}.zip.sha256"
}

resource "aws_iam_role" "s3upload" {
  name               = "lambda-${local.function}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.s3upload.json
}

data "aws_iam_policy_document" "s3upload" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.s3upload.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "s3upload" {
  name = "lambda-${local.function}-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${local.images_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = "cognito-idp:ListUsers"
        Resource = "${local.cognito_arn}"
      },
      {
        Effect   = "Allow"
        Action   = "dynamodb:PutItem"
        Resource = "${local.images_table_arn}"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3upload" {
  role       = aws_iam_role.s3upload.name
  policy_arn = aws_iam_policy.s3upload.arn
}

resource "aws_lambda_alias" "s3upload" {
  name             = "running"
  function_name    = aws_lambda_function.s3upload.function_name
  function_version = "$LATEST"
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = local.images_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_alias.s3upload.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "s3upload" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3upload.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = local.images_bucket_arn
  qualifier = "${aws_lambda_alias.s3upload.name}"
}
