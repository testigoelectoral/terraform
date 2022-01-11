
resource "aws_kms_key" "custom" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "kms:Decrypt"
        Effect   = "Deny"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
      },
      {
        Action   = "kms:*"
        Effect   = "Allow"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
      },
    ]
  })
}
