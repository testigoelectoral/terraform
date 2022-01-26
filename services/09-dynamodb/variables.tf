
locals {
  org = "testigoelectoral"
}

output "images_arn" {
  value = aws_dynamodb_table.images.arn
}

output "images_name" {
  value = aws_dynamodb_table.images.name
}

output "image_votes_arn" {
  value = aws_dynamodb_table.image-votes.arn
}

output "image_votes_name" {
  value = aws_dynamodb_table.image-votes.name
}
