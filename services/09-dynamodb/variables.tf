
locals {
  org = "testigoelectoral"
}

output "images_arn" {
  value = aws_dynamodb_table.images.arn
}

output "images_name" {
  value = aws_dynamodb_table.images.name
}

output "votes_owner_arn" {
  value = aws_dynamodb_table.votes-owner.arn
}

output "votes_owner_name" {
  value = aws_dynamodb_table.votes-owner.name
}

output "image_processing_arn" {
  value = aws_dynamodb_table.image-processing.arn
}

output "image_processing_name" {
  value = aws_dynamodb_table.image-processing.name
}
