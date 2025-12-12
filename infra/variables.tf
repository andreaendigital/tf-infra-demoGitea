# S3 Remote State

variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}

variable "name" {
  type        = string
  description = "Tag name for the S3 bucket"
}


# Networking

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}


#EC2
variable "ec2_ami_id" {
  type        = string
  description = "AMI ID to use for the EC2 instance"
}

variable "public_key" {
  type        = string
  description = "Public SSH key to associate with the EC2 instance"
}

# Security Groups

variable "my_dev_ip" {
  type        = string
  description = "CIDR block for the developer's IP to allow SSH access (e.g., 203.0.113.4/32)"
}

variable "ec2_sg_name_for_python_api" {
  type        = string
  description = "Name tag for the EC2 Security Group hosting the Python API."
}

# ====================================
# VPN Gateway Variables (Azure Connection)
# ====================================

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for connection to Azure"
  type        = bool
  default     = false
}

variable "azure_vpn_gateway_ip" {
  description = "Public IP address of Azure VPN Gateway (from Azure Terraform output)"
  type        = string
  default     = ""
}

variable "azure_vnet_cidr" {
  description = "Azure VNet CIDR block (e.g., 10.1.0.0/16)"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpn_shared_key" {
  description = "Shared key for VPN connection (must match Azure configuration)"
  type        = string
  sensitive   = true
  default     = ""
}

# ====================================
# RDS Replication Variables
# ====================================

variable "enable_binlog" {
  description = "Enable binary logging for RDS replication to Azure"
  type        = bool
  default     = false
}

variable "replication_user" {
  description = "MySQL user for replication to Azure"
  type        = string
  default     = "repl_azure"
}

variable "replication_password" {
  description = "Password for replication user"
  type        = string
  sensitive   = true
  default     = ""
}
