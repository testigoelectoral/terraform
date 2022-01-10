
output "custom_arn" {
  value = aws_kms_key.custom.arn
}

output "custom_id" {
  value = aws_kms_key.custom.key_id
}
