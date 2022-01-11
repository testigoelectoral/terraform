

resource "aws_lambda_function" "lambda" {
  function_name = "be-${local.function}-${var.environment}"

  role = aws_iam_role.role.arn

  s3_bucket        = local.artifacts_bucket
  s3_key           = "back-end/lambda/${local.function}/${local.function}.zip"
  source_code_hash = chomp(data.aws_s3_bucket_object.sha.body) # To forces deploy

  runtime = "go1.x"
  handler = "main"
  publish = true

  kms_key_arn = local.kms_key_arn
  environment {
    variables = {
      SEED_KEY = var.secret_seed
    }
  }

  depends_on = [aws_kms_grant.grant]
}

data "aws_s3_bucket_object" "sha" {
  bucket = local.artifacts_bucket
  key    = "back-end/lambda/${local.function}/${local.function}.zip.sha256"
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

resource "aws_kms_grant" "grant" {
  key_id            = local.kms_key_id
  grantee_principal = aws_iam_role.role.arn
  operations        = ["Encrypt", "Decrypt"]
}

resource "aws_lambda_alias" "running" {
  name             = "running"
  function_name    = aws_lambda_function.lambda.function_name
  function_version = "$LATEST"
}
