# Networking Outputs
output "infraGitea_vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.infraGitea_vpc_id
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