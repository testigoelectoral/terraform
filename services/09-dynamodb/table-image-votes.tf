
resource "aws_dynamodb_table" "image-votes" {

  name         = "image-votes-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageVotesID"
  range_key    = "ImageID"

  attribute {
    name = "ImageVotesID"
    type = "S"
  }

  attribute {
    name = "ImageID"
    type = "S"
  }

}
