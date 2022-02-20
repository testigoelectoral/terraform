
resource "aws_dynamodb_table" "image-processing" {

  name         = "image-processing-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ImageProcessingID"
  range_key    = "OwnerID"

  attribute {
    name = "ImageProcessingID"
    type = "S"
  }

  attribute {
    name = "OwnerID"
    type = "S"
  }

}
