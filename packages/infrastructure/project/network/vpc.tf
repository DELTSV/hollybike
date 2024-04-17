resource "aws_default_vpc" "default" {
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.namespace}_VPC_${var.environment}"
  }
}

data "aws_availability_zones" "available" {}


resource "aws_default_subnet" "public" {
  count      = var.az_count
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

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


resource "aws_eip" "nat_gateway" {
  count = var.az_count

  domain = "vpc"

  tags = {
    Name = "${var.namespace}_EIP_${count.index}_${var.environment}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = aws_default_subnet.public[count.index].id
  allocation_id = aws_eip.nat_gateway[count.index].id

  tags = {
    Name = "${var.namespace}_NATGateway_${count.index}_${var.environment}"
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block = cidrsubnet(aws_default_vpc.default.cidr_block, 4, var.az_count + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_default_vpc.default.id

  tags = {
    Name = "${var.namespace}_PrivateSubnet_${count.index}_${var.environment}"
  }
}


resource "aws_default_route_table" "default" {
  default_route_table_id = aws_default_vpc.default.main_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.namespace}_PublicRouteTable_${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_default_subnet.public[count.index].id
  route_table_id = aws_default_route_table.default.id
}

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_default_vpc.default.id
  route_table_id = aws_default_route_table.default.id
}

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.namespace}_PrivateRouteTable_${count.index}_${var.environment}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_vpc_endpoint" "secretsmanager_vpc_endpoint" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_default_vpc.default.id
  service_name      = "com.amazonaws.${var.region}.secretsmanager"
}
