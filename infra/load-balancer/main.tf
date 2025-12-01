#Input Variables
variable "lb_name" {}
variable "lb_type" {}
variable "is_external" { default = false }
variable "sg_enable_ssh_https" {}
variable "subnet_ids" {}
variable "tag_name" {}
variable "lb_target_group_arn" {}
variable "ec2_instance_id" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}
variable "lb_target_group_attachment_port" {}
# The following variables are not used because HTTPS and ACM are not configured
#variable "lb_https_listner_port" {}
#variable "lb_https_listner_protocol" {}
#variable "infraGitea_acm_arn" {}

# Outputs

output "aws_lb_dns_name" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.infraGitea_lb.dns_name
}

output "aws_lb_zone_id" {
  description = "Zone ID of the Load Balancer"
  value       = aws_lb.infraGitea_lb.zone_id
}

# Load Balancer Resource
resource "aws_lb" "infraGitea_lb" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_https]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = var.tag_name
    Project     = "infraGitea"
  }
}

# Target Group Attachment
resource "aws_lb_target_group_attachment" "infraGitea_lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instance_id
  port             = var.lb_target_group_attachment_port
}

# HTTP Listener (Port 80)
resource "aws_lb_listener" "infraGitea_lb_listener" {
  load_balancer_arn = aws_lb.infraGitea_lb.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}