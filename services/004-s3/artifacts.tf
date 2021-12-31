

resource "aws_s3_bucket" "artifacts" {
  bucket = "testigoelectoral-artifacts-${var.environment}"
  acl    = "private"
}

resource "aws_iam_user" "artifacts" {
  name = "artifacts-${var.environment}"
}

resource "aws_iam_policy" "artifacts" {
  name = "artifacts-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.artifacts.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket.artifacts]
}

resource "aws_iam_user_policy_attachment" "artifacts" {
  user       = aws_iam_user.artifacts.name
  policy_arn = aws_iam_policy.artifacts.arn
}