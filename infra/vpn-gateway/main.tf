variable "vpc_id" {
  description = "VPC ID to attach VPN Gateway"
  type        = string
}

variable "azure_vpn_gateway_ip" {
  description = "Public IP of Azure VPN Gateway"
  type        = string
}

variable "azure_vnet_cidr" {
  description = "Azure VNet CIDR block"
  type        = string
}

variable "vpn_shared_key" {
  description = "Shared key for VPN connection"
  type        = string
  sensitive   = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

# VPN Gateway (Virtual Private Gateway)
resource "aws_vpn_gateway" "main" {
  count  = var.enable_vpn_gateway ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name    = "infraGitea-vpn-gateway"
    Project = "infraGitea"
  }
}

# Customer Gateway (represents Azure VPN Gateway)
resource "aws_customer_gateway" "azure" {
  count      = var.enable_vpn_gateway ? 1 : 0
  bgp_asn    = 65000
  ip_address = var.azure_vpn_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name    = "infraGitea-azure-customer-gateway"
    Project = "infraGitea"
  }
}

# VPN Connection
resource "aws_vpn_connection" "azure" {
  count               = var.enable_vpn_gateway ? 1 : 0
  vpn_gateway_id      = aws_vpn_gateway.main[0].id
  customer_gateway_id = aws_customer_gateway.azure[0].id
  type                = "ipsec.1"
  static_routes_only  = true

  # Tunnel 1 configuration
  tunnel1_preshared_key = var.vpn_shared_key

  tags = {
    Name    = "infraGitea-vpn-connection-azure"
    Project = "infraGitea"
  }
}

# VPN Connection Route to Azure VNet
resource "aws_vpn_connection_route" "azure_vnet" {
  count                  = var.enable_vpn_gateway ? 1 : 0
  destination_cidr_block = var.azure_vnet_cidr
  vpn_connection_id      = aws_vpn_connection.azure[0].id
}

# Enable route propagation on main route table
resource "aws_vpn_gateway_attachment" "main" {
  count          = var.enable_vpn_gateway ? 1 : 0
  vpc_id         = var.vpc_id
  vpn_gateway_id = aws_vpn_gateway.main[0].id
}

# Outputs
output "vpn_gateway_id" {
  description = "VPN Gateway ID"
  value       = var.enable_vpn_gateway ? aws_vpn_gateway.main[0].id : null
}

output "customer_gateway_id" {
  description = "Customer Gateway ID"
  value       = var.enable_vpn_gateway ? aws_customer_gateway.azure[0].id : null
}

output "vpn_connection_id" {
  description = "VPN Connection ID"
  value       = var.enable_vpn_gateway ? aws_vpn_connection.azure[0].id : null
}

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of VPN tunnel 1"
  value       = var.enable_vpn_gateway ? aws_vpn_connection.azure[0].tunnel1_address : null
}

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of VPN tunnel 2"
  value       = var.enable_vpn_gateway ? aws_vpn_connection.azure[0].tunnel2_address : null
}
