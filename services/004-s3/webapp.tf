

resource "aws_s3_bucket" "webapp" {
  bucket = "testigoelectoral-webapp-${var.environment}"
  acl    = "private"
}
