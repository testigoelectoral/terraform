
resource "aws_kms_key" "custom" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        NotAction = "kms:Decrypt"
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
      },
    ]
  })
}
