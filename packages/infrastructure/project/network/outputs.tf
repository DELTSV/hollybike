output "public_subnet_list" {
  value = aws_default_subnet.public.*.id
}

output "vpc_id" {
  value = aws_default_vpc.default.id
}