

resource "aws_lambda_function" "hash" {
  function_name = "backend-${local.function.hash}-${var.environment}"

  role = aws_iam_role.hash.arn

  s3_bucket        = local.artifacts_bucket
  s3_key           = "back-end/lambda/${local.function.hash}/${local.function.hash}.zip"
  source_code_hash = chomp(data.aws_s3_bucket_object.hash.body) # To forces deploy

  runtime = "go1.x"
  handler = "main"
  publish = true

  kms_key_arn = local.kms_key_arn
  environment {
    variables = {
      SEED_KEY = var.secret_seed
    }
  }

  depends_on = [aws_kms_grant.hash]
}

data "aws_s3_bucket_object" "hash" {
  bucket = local.artifacts_bucket
  key    = "back-end/lambda/${local.function.hash}/${local.function.hash}.zip.sha256"
}

resource "aws_iam_role" "hash" {
  name               = "lambda-${local.function.hash}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.hash.json
}

data "aws_iam_policy_document" "hash" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "hash" {
  role       = aws_iam_role.hash.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_kms_grant" "hash" {
  key_id            = local.kms_key_id
  grantee_principal = aws_iam_role.hash.arn
  operations        = ["Encrypt", "Decrypt"]
}

resource "aws_lambda_alias" "hash" {
  name             = "running"
  function_name    = aws_lambda_function.hash.function_name
  function_version = "$LATEST"
}
