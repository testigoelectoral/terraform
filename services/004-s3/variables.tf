
locals {
  org    = "testigoelectoral"
  domain = "testigoelectoral.org"
}

output "bucket_images" {
  value = aws_s3_bucket.images.id
}

output "arn_images" {
  value = aws_s3_bucket.images.arn
}

output "bucket_artifacts" {
  value = aws_s3_bucket.artifacts.id
}

output "arn_artifacts" {
  value = aws_s3_bucket.artifacts.arn
}

output "bucket_webapp" {
  value = aws_s3_bucket.webapp.id
}

output "arn_webapp" {
  value = aws_s3_bucket.webapp.arn
}

output "user_artifacts" {
  value = aws_iam_user.artifacts.name
}
