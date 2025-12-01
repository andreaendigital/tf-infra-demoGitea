# Input Variables
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "eu_availability_zone" {}
variable "cidr_private_subnet" {}

# Outputs

output "infraGitea_vpc_id" {
  description = "ID of the created VPC"
  value = aws_vpc.infraGitea_vpc.id
}

output "infraGitea_public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.infraGitea_public_subnets[*].id
}

output "public_subnet_cidr_block"{
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.infraGitea_public_subnets[*].cidr_block
}


# Setup VPC
resource "aws_vpc" "infraGitea_vpc" {

  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
    Project     = "infraGitea"
  }
}


# Setup public subnet
resource "aws_subnet" "infraGitea_public_subnets" {
  count             = length(var.cidr_public_subnet)
  vpc_id            = aws_vpc.infraGitea_vpc.id
  cidr_block        = element(var.cidr_public_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name        = "infraGitea-public-subnet-${count.index + 1}"
    Project     = "infraGitea"
  }

}

# Setup private subnet
resource "aws_subnet"  "infraGitea_private_subnets" {
  count             = length(var.cidr_private_subnet)
  vpc_id            = aws_vpc.infraGitea_vpc.id
  cidr_block        = element(var.cidr_private_subnet, count.index)
  availability_zone = element(var.eu_availability_zone, count.index)

  tags = {
    Name        = "infraGitea-private-subnet-${count.index + 1}"
    Project     = "infraGitea"
  }

}

# Setup Internet Gateway
resource "aws_internet_gateway" "infraGitea_igw" {
  vpc_id = aws_vpc.infraGitea_vpc.id

  tags = {
    Name        = "infraGitea-igw"
    Project     = "infraGitea"
  }
}


# Public Route Table
resource "aws_route_table" "infraGitea_public_rt" {
  vpc_id = aws_vpc.infraGitea_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infraGitea_igw.id

  }
  tags = {
    Name        = "infraGitea-public-rt"
    Project     = "infraGitea"
  }

}

# Public Route Table and Public Subnet Association
resource "aws_route_table_association" "infraGitea_public_rt_association" {
  count          = length(aws_subnet.infraGitea_public_subnets)
  subnet_id      = aws_subnet.infraGitea_public_subnets[count.index].id
  route_table_id = aws_route_table.infraGitea_public_rt.id
}

# Private Route Table
resource "aws_route_table" "infraGitea_private_rt" {
  vpc_id = aws_vpc.infraGitea_vpc.id

  tags = {
    Name        = "infraGitea-private-rt"
    Project     = "infraGitea"
  }
}


# Private Route Table and private Subnet Association
resource "aws_route_table_association" "infraGitea_private_rt_association" {
  count          = length(aws_subnet.infraGitea_private_subnets)
  subnet_id      = aws_subnet.infraGitea_private_subnets[count.index].id
  route_table_id = aws_route_table.infraGitea_private_rt.id
}

#This module creates a VPC with public and private subnets, an internet gateway, and route tables. We use variables for flexibility, tags for traceability, and count-based logic for scalability.