resource "aws_default_vpc" "default" {
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.namespace}_VPC_${var.environment}"
  }
}

data "aws_availability_zones" "available" {}


resource "aws_default_subnet" "public" {
  count                           = var.az_count
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch         = true

  assign_ipv6_address_on_creation = true

  ipv6_cidr_block = cidrsubnet(aws_default_vpc.default.ipv6_cidr_block, 4, count.index)

  tags = {
    Name = "${var.namespace}_PublicSubnet_${count.index}_${var.environment}"
  }
}


data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_default_vpc.default.main_route_table_id

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = data.aws_internet_gateway.default.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.namespace}_PublicRouteTable_${var.environment}"
  }
}

resource "aws_vpc_endpoint" "secretsmanager_vpc_endpoint" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_default_vpc.default.id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
}
