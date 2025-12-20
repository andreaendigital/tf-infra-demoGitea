# S3 bucket for remote state, created manually
bucket_name = "infraGitea-remote-state-bucket"
name        = "infraGitea"

# VPC configuration (Free Tier compatible CIDR blocks)
vpc_cidr = "10.0.0.0/16"
vpc_name = "infraGitea-eu-central-vpc"

# Public subnets (for ALB and Jenkins EC2)
cidr_public_subnet = ["10.0.1.0/24", "10.0.2.0/24"]

# Private subnets (for RDS or backend services)
cidr_private_subnet = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_group_name = "infragitea-rds-subnet-group"

# Availability Zones in us-east-1 (Free Tier region)
eu_availability_zone = ["us-east-1a", "us-east-1b"]

# EC2 configuration
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPcFMh4kzsdK1ehKBlISe2yud896rXDckuc6ltyQ14HddTabb15U1L/AK3GQ7fIfdxXLg4zvm/GLxIwGg1axemtxyEI4E/ibFep23yaVLiW8M8xUow60I4mANLE3UZqAKP4LhbaWQUShTgvg69Tp0PkU8YfBIyqGQiaBea4Mk8K4vVbHDcxmHtveoD/XAVTum65rlFd4AtLaWx5Ul3Pz2Z3mUmkIDwbRgYxyf7b+G3A6sy+kowVxnwe8pRZ/JABPKwzZs2UWZKdxuEMU5ks8r73aZKL8Avgb5H+lZkmvAWWGD0R5iN+Bqg8HZAT1RJvwa0DeIhS7qx28Sn88zMRCVexk9PQIOK4/sANzPZRNhjO7HdhiGdgK9NYmfbJ5GJr/TQytlyc+ox0Dr9qNsDI2RfTpQT6nEPLa7j7xDfSGRvWPnCtakhAjL80QUN06i+1+hOZbjzfS9BQfHczvXMXgf7NVsmwS3V1ndDWYTkfJp9irw2Y3bNtARgsxHd/GVlUceIffqIJ4rUgSzPCnoGJEILFGQ87hfnBQK/0FnTStrRzRVUZ3O3x3xX41gdvDih6h8JaLvyJbyvJw3xPJ2Ezx5CdetH1v1adrTxFbkba+4Clr7XeB+E7m9j6FZwMY36oc6rUzmnzPH22T94TXni3rkWQjsXi6a5EjwywRdtsfr2DQ== andrea@DESKTOP-F5IP3TM"
ec2_ami_id = "ami-0157af9aea2eef346" # Amazon Linux 2023 AMI (Free Tier eligible)
ec2_sg_name_for_python_api = "infraGitea-python-api-sg"

# Security variable
my_dev_ip = "203.0.113.4/32"

# ====================================
# VPN Gateway Configuration (Azure Connection)
# ====================================
enable_vpn_gateway    = true
azure_vpn_gateway_ip  = "172.191.103.7"  # Azure VPN Gateway public IP
azure_vnet_cidr       = "10.1.0.0/16"
vpn_shared_key        = "GitDemoSecureKey2025!"  # Must match Azure configuration

# ====================================
# RDS Replication Configuration
# ====================================
enable_binlog         = true   # Enable binary logging for replication to Azure
# Note: replication_user and replication_password are configured in AWS RDS
# User: repl_azure with REPLICATION SLAVE privileges
# Password is stored in Jenkins credentials as 'aws-replication-password'

# ====================================
# Splunk Observability Cloud
# ====================================
splunk_observability_token = "PZuf3J0L2Op_Qj9hpAJzlw"
splunk_realm               = "us1"
app_port                   = 3000
app_name                   = "gitea"