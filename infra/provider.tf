terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Connection to AWS provider
provider "aws" {
  region = "us-east-1"
  #profile = "terraform-user"
  shared_credentials_files = ["~/.aws/credentials"]

}

# AWS provider configuration using shared credentials file, sourced from ~/.aws/credentials and ~/.aws/config
# Avoid hardcoding access_key and secret_key. 
# Use AWS CLI to configure: `aws configure` or manually edit the files to set up credentials
# Make sure both files include a [terraform-user] block with valid access keys and region
