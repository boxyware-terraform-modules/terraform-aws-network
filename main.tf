#-----------------------------------------------------------------------------------
# VPC
#-----------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    { Name = var.name },
    var.labels,
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = var.name },
    var.labels,
  )
}

resource "aws_route_table" "ig" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    { Name = var.name },
    var.labels,
  )
}

resource "aws_main_route_table_association" "this" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.ig.id
}

#-----------------------------------------------------------------------------------
# Subnets
#-----------------------------------------------------------------------------------
resource "aws_subnet" "public_subnet" {
  for_each = { for x in var.public_subnets : x.suffix => x }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.name}-public-${each.value.suffix}" },
    var.labels,
  )
}

resource "aws_subnet" "private_subnet" {
  for_each = { for x in var.private_subnets : x.suffix => x }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(
    { Name = "${var.name}-private-${each.value.suffix}" },
    var.labels,
  )
}
 
#-----------------------------------------------------------------------------------
# NAT
#-----------------------------------------------------------------------------------
resource "aws_eip" "nat_eip" {
  count = var.enable_nat && length(var.public_subnets) > 0 ? 1 : 0
  vpc   = true
}

resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat && length(var.public_subnets) > 0 ? 1 : 0
  allocation_id = aws_eip.nat_eip.0.id
  subnet_id     = aws_subnet.public_subnet[var.public_subnets[0].suffix].id
 
  tags = merge(
    { Name = var.name },
    var.labels,
  )
}