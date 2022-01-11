

resource "aws_s3_bucket" "artifacts" {
  bucket = "testigoelectoral-artifacts-${var.environment}"
  acl    = "private"
}
