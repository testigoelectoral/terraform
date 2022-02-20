resource "aws_iam_role" "myimages" {
  name               = "apigw-myimages-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.myimages-assume.json
}

data "aws_iam_policy_document" "myimages-assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "myimages" {
  name = "apigw-myimages-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${local.images_bucket_arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:Query", "dynamodb:Scan"]
        Resource = [local.dynamodb_images_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:Scan", "dynamodb:PutItem"]
        Resource = [local.dynamodb_votes_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["dynamodb:Query", "dynamodb:PutItem"]
        Resource = [local.dynamodb_processing_arn]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.myimages.name
  policy_arn = aws_iam_policy.myimages.arn
}
