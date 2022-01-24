
resource "aws_dynamodb_table" "images-votes" {

  name         = "images-votes-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageId"

  attribute {
    name = "ImageId"
    type = "S"
  }

}