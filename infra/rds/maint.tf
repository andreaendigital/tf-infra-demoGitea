variable "db_subnet_group_name" {}
variable "subnet_groups" {}
variable "rds_mysql_sg_id" {}
variable "mysql_db_identifier" {}
variable "mysql_username" {}
variable "mysql_password" {}
variable "mysql_dbname" {}

# RDS Subnet Group
resource "aws_db_subnet_group" "infraGitea_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_groups # replace with your private subnet IDs

    tags = {
    Name        = var.db_subnet_group_name
    Project     = "infraGitea"
  }

}

# RDS MySQL Instance Resource
resource "aws_db_instance" "default" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  identifier              = var.mysql_db_identifier
  username                = var.mysql_username
  password                = var.mysql_password
  vpc_security_group_ids  = [var.rds_mysql_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.infraGitea_db_subnet_group.name
  db_name                 = var.mysql_dbname
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false

    tags = {
    Name        = var.mysql_db_identifier
    Project     = "infraGitea"
  }

}
# Outputs
output "infraGitea_rds_endpoint" {
  description = "RDS MySQL endpoint for infraGitea"
  value       = aws_db_instance.default.endpoint
}

output "infraGitea_rds_address" {
  description = "RDS MySQL address (without port) for infraGitea"
  value       = aws_db_instance.default.address
}

output "infraGitea_rds_port" {
  description = "RDS MySQL port for infraGitea"
  value       = aws_db_instance.default.port
}

output "infraGitea_rds_db_name" {
  description = "RDS database name for infraGitea"
  value       = aws_db_instance.default.db_name
}
