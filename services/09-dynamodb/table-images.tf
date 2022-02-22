
resource "aws_dynamodb_table" "images" {

  name         = "images-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "OwnerSub"
  range_key    = "ImageID"

  attribute {
    name = "OwnerSub"
    type = "S"
  }

  attribute {
    name = "ImageID"
    type = "S"
  }
}
