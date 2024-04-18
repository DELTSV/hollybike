# output list with only the first 2 subnets to save costs

output "public_subnet_list" {
  value = slice(aws_default_subnet.public.*.id, 0, 2)
}

output "vpc_id" {
  value = aws_default_vpc.default.id
}