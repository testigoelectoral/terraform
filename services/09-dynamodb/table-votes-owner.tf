
resource "aws_dynamodb_table" "votes-owner" {

  name         = "votes-owner-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageID"
  range_key    = "Original"

  attribute {
    name = "ImageID"
    type = "S"
  }

  attribute {
    name = "Original"
    type = "N"
  }
}
