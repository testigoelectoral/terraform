
resource "aws_dynamodb_table" "image-processing" {

  name         = "image-processing-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "OwnerID"
  range_key    = "ImageID"

  attribute {
    name = "OwnerID"
    type = "S"
  }

  attribute {
    name = "ImageID"
    type = "S"
  }
}
