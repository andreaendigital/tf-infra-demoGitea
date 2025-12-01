# VARIABLES
/*
variable "bucket_name" {
  description = "Name of the S3 bucket used for remote state"
}
variable "name" {}

# Output
output "infraCar_remote_state_bucket_name" {
  description = "Name of the S3 bucket used for remote state"
  value       = aws_s3_bucket.infraCar_remote_state_bucket.id
}

# S3 Bucket Resource

resource "aws_s3_bucket" "infraCar_remote_state_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.name
    Environment = var.environment
    Project     = "infraCar"
  }
}
*/