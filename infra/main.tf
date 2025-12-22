# Gitea Infrastructure - Main Configuration
# 
# SECURITY NOTE: Database credentials in this file are default values for Terraform state only.
# Actual production credentials are securely managed via Jenkins Credentials Manager
# and passed to Ansible during deployment. These hardcoded values are overridden at runtime.
#
# Credentials flow: Jenkins Credentials -> Ansible extra-vars -> RDS Configuration

# Networking module: creates VPC, public and private subnets in us-east-1
module "networking" {
  source               = "./networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
  enable_vpn_gateway   = var.enable_vpn_gateway
  vpn_gateway_id       = module.vpn_gateway.vpn_gateway_id
}


#Security group module: enables SSH, HTTP, HTTPS and port access for api
module "security_group" {
  source                     = "./security-groups"
  ec2_sg_name                = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  vpc_id                     = module.networking.infraGitea_vpc_id
  public_subnet_cidr_block   = tolist(module.networking.public_subnet_cidr_block)
  ec2_sg_name_for_python_api = "SG for EC2 for enabling port 5000"
  vpc_cidr                   = var.vpc_cidr
  my_dev_ip                  = var.my_dev_ip
}

# Jenkins EC2 instance module: deploys Jenkins on Amazon Linux with user_data script
module "ec2" {
  source                        = "./ec2"
  ami_id                        = var.ec2_ami_id
  instance_type                 = "t3.small" # Free Tier compatible
  tag_name                      = "Amazon Linux EC2"
  public_key                    = var.public_key
  subnet_id                     = tolist(module.networking.infraGitea_public_subnets)[0]
  sg_enable_ssh_https           = module.security_group.sg_ec2_sg_ssh_http_id
  ec2_sg_name_for_python_api    = module.security_group.sg_ec2_for_python_api
  enable_public_ip_address      = true

}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance, exposed from the EC2 module."
  value       = module.ec2.ec2_public_ip 
}
# Target group for EC2 instance
module "lb_target_group" {
  source                   = "./load-balancer-target-group"
  lb_target_group_name     = "infraGitea-lb-target-group"
  lb_target_group_port     = 3000
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.infraGitea_vpc_id
  ec2_instance_id          = module.ec2.infraGitea_ec2_instance_id
}

# Application Load Balancer module
module "alb" {
  source                    = "./load-balancer"
  lb_name                   = "infraGitea-alb"
  is_external               = false
  lb_type                   = "application"
  sg_enable_ssh_https       = module.security_group.sg_ec2_sg_ssh_http_id
  subnet_ids                = tolist(module.networking.infraGitea_public_subnets)
  tag_name                  = "infraGitea-alb"
  lb_target_group_arn       = module.lb_target_group.infraGitea_lb_target_group_arn
  ec2_instance_id           = module.ec2.infraGitea_ec2_instance_id
  lb_listner_port           = 80
  lb_listner_protocol       = "HTTP"
  lb_listner_default_action = "forward"
  lb_target_group_attachment_port = 5000
}

module "rds_db_instance" {
  source               = "./rds"
  db_subnet_group_name = "infragitea-rds-subnet-group"
  subnet_groups        = tolist(module.networking.infraGitea_private_subnets)
  rds_mysql_sg_id      = module.security_group.rds_mysql_sg_id
  mysql_db_identifier  = "mydb"
  mysql_username       = "dbuser"
  mysql_password       = "dbpassword"
  mysql_dbname         = "infraGiteaDB"
  enable_binlog        = var.enable_binlog
}

# VPN Gateway module for Azure connection
module "vpn_gateway" {
  source                = "./vpn-gateway"
  vpc_id                = module.networking.infraGitea_vpc_id
  enable_vpn_gateway    = var.enable_vpn_gateway
  azure_vpn_gateway_ip  = var.azure_vpn_gateway_ip
  azure_vnet_cidr       = var.azure_vnet_cidr
  vpn_shared_key        = var.vpn_shared_key
}


# Route53 and SSL Certificate Manager (commented out)
# Uncomment to enable custom domain and HTTPS support
/*
module "hosted_zone" {
  source          = "./hosted-zone"
  domain_name     = "your-domain.com"
  aws_lb_dns_name = module.alb.aws_lb_dns_name
  aws_lb_zone_id  = module.alb.aws_lb_zone_id
}

module "aws_ceritification_manager" {
  source         = "./certificate-manager"
  domain_name    = "your-domain.com"
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}
*/
output "infraGitea_rds_endpoint" {
  description = "RDS MySQL endpoint for infraGitea database"
  value       = module.rds_db_instance.infraGitea_rds_endpoint
}

output "infraGitea_rds_address" {
  description = "RDS MySQL address for infraGitea database"
  value       = module.rds_db_instance.infraGitea_rds_address
}

# Note: These credentials are default values for Terraform outputs only.
# Actual credentials are managed securely via Jenkins Credentials Manager
# and passed to Ansible at deployment time.
output "infraGitea_mysql_username" {
  description = "MySQL username for infraGitea (default value, overridden by Jenkins)"
  value       = "dbuser"
  sensitive   = true
}

output "infraGitea_mysql_password" {
  description = "MySQL password for infraGitea (default value, overridden by Jenkins)"
  value       = "dbpassword"
  sensitive   = true
}

output "infraGitea_mysql_dbname" {
  description = "MySQL database name for infraGitea"
  value       = "infraGiteaDB"
}
