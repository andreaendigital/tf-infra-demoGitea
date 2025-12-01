#Input Variables
variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "enable_public_ip_address" {}
#variable "user_data_install_apache" {}
variable "ec2_sg_name_for_python_api" {}

#Outputs
output "ssh_connection_string_for_ec2" {
  description = "SSH command to connect to the EC2 instance"
  value       = format("ssh -i /home/ubuntu/keys/aws_ec2_terraform ec2-user@%s", aws_instance.infraGitea_ec2.public_ip)
}

output "infraGitea_ec2_instance_id" {
  description = "ID of the EC2 instance"
  value = aws_instance.infraGitea_ec2.id
}

output "infraGitea_ec2_instance_ip" { 
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.infraGitea_ec2.private_ip 
}

output "ec2_public_ip" { 
    description = "Public IP address of the EC2 instance"
    value       = aws_instance.infraGitea_ec2.public_ip
}

#EC2 Instance Resource
resource "aws_instance" "infraGitea_ec2" {
   ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.infraGitea_key.key_name
  vpc_security_group_ids      = [var.sg_enable_ssh_https, var.ec2_sg_name_for_python_api]
  associate_public_ip_address = var.enable_public_ip_address
  #user_data                   = var.user_data_install_apache

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }

  tags = {
    Name        = var.tag_name
    Environment = "dev"
    Project     = "infraGitea"
  }

}

resource "aws_key_pair" "infraGitea_key" {
  key_name   = "aws_key"
  public_key = var.public_key
}
