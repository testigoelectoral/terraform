
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
