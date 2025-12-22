# Input Variables
variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "public_subnet_cidr_block" {}
variable "ec2_sg_name_for_python_api" {}
variable "vpc_cidr" {}
variable "my_dev_ip" {
  description = "Developer IP for SSH access restriction (e.g., 203.0.113.4/32). Default allows all."
  default     = "0.0.0.0/0"
}

# Outputs
output "sg_ec2_sg_ssh_http_id" {
  description = "ID of the EC2 security group for SSH and HTTP"
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "rds_mysql_sg_id" {
  description = "ID of the RDS MySQL security group"
  value = aws_security_group.rds_mysql_sg.id
}

output "sg_ec2_for_python_api" {
  description = "ID of the EC2 security group for Python API"
  value = aws_security_group.ec2_sg_python_api.id

}

# --- Bloque 1: Security Group for EC2 (SSH + HTTP + HTTPS) ---
resource "aws_security_group" "ec2_sg_ssh_http" {
  name        = var.ec2_sg_name
  description = "Enable the Port 22(SSH) & Port 80(http) and https(443)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow remote SSH from anywhere for Terraform and Ansible"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP request from anywhere (Public Access)"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTPS request from anywhere (Public Access)"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    description = "Allow outgoing request to all destinations"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Security Groups to allow SSH(22) and HTTP(80) and https(443)"
    Project     = "infraGitea"
  }
}

# --- Bloque 2: Security Group for RDS ---
resource "aws_security_group" "rds_mysql_sg" {
  name        = "infraGitea-rds-sg"
  description = "Allow access to RDS from EC2 present in public subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic only from EC2 SG"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
  }

  ingress {
    description = "Allow MySQL traffic from Azure VNet via VPN"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }

  egress {
    description = "Allow all outbound traffic only within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name        = "infraGitea-rds-sg"
    Project     = "infraGitea"
  }
}

# --- Bloque 3: Security Group for Python API (Port 5000) ---
resource "aws_security_group" "ec2_sg_python_api" {
  name        = var.ec2_sg_name_for_python_api
  description = "Enable ports for CarPrice app (3000, 5000, 5002, 5004)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow traffic on port 5000 only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id] 
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }

  ingress {
    description = "Allow traffic on port 3000 (Web App) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
  }

  ingress {
    description = "Allow traffic on port 5002 (Backend API) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
  }

  ingress {
    description = "Allow traffic on port 5004 (Documentation) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 5004
    to_port     = 5004
    protocol    = "tcp"
  }

  egress {
    description = "Allow all outbound traffic only within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name        = var.ec2_sg_name_for_python_api
    Project     = "infraGitea"
  }
}