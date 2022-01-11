

resource "aws_s3_bucket" "images" {
  bucket = "testigoelectoral-images${var.environment == "prod" ? "" : format("-%s", var.environment)}"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = ["https://app${var.environment == "prod" ? "" : format("-%s", var.environment)}.testigoelectoral.org"]
  }
}