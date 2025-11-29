# Input Variables
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}

# Outputs

output "infraCar_vpc_id" {
  description = "ID of the created VPC"
  value = aws_vpc.infraCar_vpc.id
}

output "infraCar_public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.infraCar_public_subnets[*].id
}

output "public_subnet_cidr_block"{
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.infraCar_public_subnets[*].cidr_block
}


# Setup VPC
resource "aws_vpc" "infraCar_vpc" {

  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
    Project     = "infraCar"
  }
}


# Setup public subnet
resource "aws_subnet" "infraCar_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.infraCar_vpc.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name        = "infraCar-public-subnet-${count.index + 1}"
    Project     = "infraCar"
  }

}

# Setup private subnet
resource "aws_subnet"  "infraCar_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.infraCar_vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name        = "infraCar-private-subnet-${count.index + 1}"
    Project     = "infraCar"
  }

}

# Setup Internet Gateway
resource "aws_internet_gateway" "infraCar_igw" {
  vpc_id = aws_vpc.infraCar_vpc.id

  tags = {
    Name        = "infraCar-igw"
    Project     = "infraCar"
  }
}


# Public Route Table
resource "aws_route_table" "infraCar_public_rt" {
  vpc_id = aws_vpc.infraCar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infraCar_igw.id

  }
  tags = {
    Name        = "infraCar-public-rt"
    Project     = "infraCar"
  }

}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "infraCar_public_rt_association" {
  count          = length(aws_subnet.infraCar_public_subnets)
  subnet_id      = aws_subnet.infraCar_public_subnets[count.index].id
  route_table_id = aws_route_table.infraCar_public_rt.id
}

# Private Route Table
resource "aws_route_table" "infraCar_private_rt" {
  vpc_id = aws_vpc.infraCar_vpc.id

  tags = {
    Name        = "infraCar-private-rt"
    Project     = "infraCar"
  }
}


# Private Route Table and private Subnet Association
resource "aws_route_table_association" "infraCar_private_rt_association" {
  count          = length(aws_subnet.infraCar_private_subnets)
  subnet_id      = aws_subnet.infraCar_private_subnets[count.index].id
  route_table_id = aws_route_table.infraCar_private_rt.id
}

#This module creates a VPC with public and private subnets, an internet gateway, and route tables. We use variables for flexibility, tags for traceability, and count-based logic for scalability.