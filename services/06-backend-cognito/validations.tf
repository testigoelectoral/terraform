

resource "aws_lambda_function" "validations" {
  function_name = "backend-${local.function.validations}-${var.environment}"

  role = aws_iam_role.validations.arn

  s3_bucket        = local.artifacts_bucket
  s3_key           = "back-end/lambda/${local.function.validations}/${local.function.validations}.zip"
  source_code_hash = chomp(data.aws_s3_bucket_object.validations.body) # To forces deploy

  runtime = "go1.x"
  handler = "main"
  publish = true
}

data "aws_s3_bucket_object" "validations" {
  bucket = local.artifacts_bucket
  key    = "back-end/lambda/${local.function.validations}/${local.function.validations}.zip.sha256"
}

resource "aws_iam_role" "validations" {
  name               = "lambda-${local.function.validations}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.validations.json
}

data "aws_iam_policy_document" "validations" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "validations" {
  role       = aws_iam_role.validations.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_alias" "validations" {
  name             = "running"
  function_name    = aws_lambda_function.validations.function_name
  function_version = "$LATEST"
}
