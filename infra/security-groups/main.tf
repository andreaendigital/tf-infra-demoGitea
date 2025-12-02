# Input Variables
variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "public_subnet_cidr_block" {}
variable "ec2_sg_name_for_python_api" {}
variable "vpc_cidr" {} # NUEVA VARIABLE: El CIDR de tu VPC (e.g., 10.0.0.0/16)
variable "my_dev_ip" { # NUEVA VARIABLE: Para restringir SSH a tu IP (e.g., "203.0.113.4/32")
  default = "0.0.0.0/0" # Usar un default inseguro si no se proporciona, pero se recomienda cambiar.
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

  # ssh for terraform remote exec and Ansible
  # Allow SSH from anywhere for Jenkins/Ansible access
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }  # enable http
  #  Si está detrás de un Load Balancer, se recomienda usar el SG del LB.
  # Aquí mantenemos 0.0.0.0/0 asumiendo que es público, pero si es un backend, debe ser el SG del LB.
  ingress {
    description = "Allow HTTP request from anywhere (Public Access)"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # enable https
  # Igual que HTTP, se mantiene público si la aplicación es pública.
  ingress {
    description = "Allow HTTPS request from anywhere (Public Access)"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  #Outgoing request
  # Se mantiene 0.0.0.0/0 para salida a Internet (necesario para repositorios, updates).
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

  # Regla de entrada RDS: Ya es segura porque usa var.public_subnet_cidr_block (o debería usar el SG de EC2)
  # BUENA PRÁCTICA: Cambiar a usar el SG de la EC2 que consume la DB
  ingress {
    description = "Allow MySQL traffic only from EC2 SG"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # CAMBIO 5: Reemplaza cidr_blocks por security_groups para mayor seguridad
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
  }

  # Restringe la salida de la DB a la VPC o solo a la EC2 (mejor, pero más complejo). 
  # Restringir a la VPC es un buen punto medio.
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

  # ssh for terraform remote exec, Original port
  # Restringe acceso a la API (Puerto 5000) solo desde la EC2 principal.
  ingress {
    description = "Allow traffic on port 5000 only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id] 
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
  }

  # Web Application
  # Restringe acceso a la Web App (Puerto 3000) solo desde la EC2 principal.
  ingress {
    description = "Allow traffic on port 3000 (Web App) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
  }

  # Backend API
  # Restringe acceso a Backend API (Puerto 5002) solo desde la EC2 principal.
  ingress {
    description = "Allow traffic on port 5002 (Backend API) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
  }

  # Documentation
  # Restringe acceso a Documentación (Puerto 5004) solo desde la EC2 principal.
  ingress {
    description = "Allow traffic on port 5004 (Documentation) only from EC2 SG"
    security_groups = [aws_security_group.ec2_sg_ssh_http.id]
    from_port   = 5004
    to_port     = 5004
    protocol    = "tcp"
  }

  # Restringe la salida de la API a la VPC (opcional, igual que RDS).
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