# output list with only the first subnet to save costs

output "public_subnet_list" {
  value = [aws_default_subnet.public[0].id]
}

output "vpc_id" {
  value = aws_default_vpc.default.id
}