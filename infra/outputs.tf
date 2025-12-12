# Networking Outputs
output "infraGitea_vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.infraGitea_vpc_id
}

# ====================================
# VPN Gateway Outputs (for Azure connection)
# ====================================

output "vpn_gateway_id" {
  description = "AWS VPN Gateway ID"
  value       = module.vpn_gateway.vpn_gateway_id
}

output "vpn_tunnel1_address" {
  description = "Public IP of VPN tunnel 1 (use this in Azure Local Network Gateway)"
  value       = module.vpn_gateway.vpn_connection_tunnel1_address
}

output "vpn_tunnel2_address" {
  description = "Public IP of VPN tunnel 2 (backup)"
  value       = module.vpn_gateway.vpn_connection_tunnel2_address
}

# ====================================
# RDS Outputs (for replication to Azure)
# ====================================

output "rds_endpoint_for_replication" {
  description = "RDS endpoint to use in Azure MySQL replication configuration"
  value       = module.rds_db_instance.infraGitea_rds_address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = module.rds_db_instance.infraGitea_rds_port
}

output "replication_user" {
  description = "MySQL replication user (create this user manually on RDS)"
  value       = var.enable_binlog ? var.replication_user : "N/A - binlog not enabled"
}


/*
output "infraGitea_ec2_ssh_connection" {
  description = "SSH command to connect to the EC2 instance"
  value       = module.ec2.ssh_connection_string_for_ec2
}

output "infraGitea_ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2.infraGitea_ec2_instance_id
}

*/