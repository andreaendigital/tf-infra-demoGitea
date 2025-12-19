variable "db_subnet_group_name" {}
variable "subnet_groups" {}
variable "rds_mysql_sg_id" {}
variable "mysql_db_identifier" {}
variable "mysql_username" {}
variable "mysql_password" {}
variable "mysql_dbname" {}
variable "enable_binlog" {
  description = "Enable binary logging for replication"
  type        = bool
  default     = false
}

# RDS Subnet Group
resource "aws_db_subnet_group" "infraGitea_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_groups # replace with your private subnet IDs

    tags = {
    Name        = var.db_subnet_group_name
    Project     = "infraGitea"
  }

}

# Parameter Group for Binlog Support (Replication)
resource "aws_db_parameter_group" "replication" {
  count       = var.enable_binlog ? 1 : 0
  name        = "${var.mysql_db_identifier}-binlog-params"
  family      = "mysql8.0"
  description = "Parameter group for MySQL replication with binlog enabled"

  parameter {
    name  = "binlog_format"
    value = "ROW"
  }

  # Note: binlog_expire_logs_seconds is not modifiable in RDS
  # RDS manages binlog retention automatically based on backup_retention_period

  tags = {
    Name    = "${var.mysql_db_identifier}-binlog-params"
    Project = "infraGitea"
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
  backup_retention_period = var.enable_binlog ? 1 : 0  # Free tier supports max 1 day retention
  parameter_group_name    = var.enable_binlog ? aws_db_parameter_group.replication[0].name : null
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
