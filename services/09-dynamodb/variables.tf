
locals {
  org = "testigoelectoral"
}

output "images_arn" {
  value = aws_dynamodb_table.images.arn
}

output "images_name" {
  value = aws_dynamodb_table.images.name
}

output "images_votes_arn" {
  value = aws_dynamodb_table.images-votes.arn
}

output "images_votes_name" {
  value = aws_dynamodb_table.images-votes.name
}
