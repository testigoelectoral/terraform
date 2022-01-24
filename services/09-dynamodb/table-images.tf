
resource "aws_dynamodb_table" "images" {

  name         = "images-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageId"
  range_key    = "OwnerSub"

  attribute {
    name = "ImageId"
    type = "S"
  }

  attribute {
    name = "OwnerSub"
    type = "S"
  }

}
