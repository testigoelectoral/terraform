resource "aws_iam_role" "images" {
  name               = "apigw-images-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.images-assume.json
}

data "aws_iam_policy_document" "images-assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "images" {
  name = "apigw-images-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${local.images_bucket_arn}/*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach-images" {
  role       = aws_iam_role.images.name
  policy_arn = aws_iam_policy.images.arn
}
