variable "splunk_observability_token" {
  description = "Splunk Observability Cloud token for authentication"
  type        = string
  sensitive   = true
}

variable "splunk_realm" {
  description = "Splunk realm (us0, us1, eu0, etc.)"
  type        = string
  default     = "us1"
}

variable "app_port" {
  description = "Application port to monitor"
  type        = number
  default     = 3000
}

variable "app_name" {
  description = "Application name for monitoring"
  type        = string
  default     = "gitea"
}

output "splunk_config" {
  description = "Splunk Observability configuration for Ansible"
  value = {
    token    = var.splunk_observability_token
    realm    = var.splunk_realm
    app_port = var.app_port
    app_name = var.app_name
  }
  sensitive = true
}
