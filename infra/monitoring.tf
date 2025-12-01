# Splunk Observability Cloud integration variables
variable "splunk_observability_token" {
  description = "Splunk Observability Cloud token"
  type        = string
  default     = "PZuf3J0L2Op_Qj9hpAJzlw"
  sensitive   = true
}

variable "splunk_realm" {
  description = "Splunk realm"
  type        = string
  default     = "us1"
}

# Output for Ansible
output "splunk_config" {
  value = {
    token = var.splunk_observability_token
    realm = var.splunk_realm
  }
  sensitive = true
}