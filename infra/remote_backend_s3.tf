terraform {
  backend "s3" {
    bucket         = "infracar-terraform-state"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    #profile        = "terraform-user"
    encrypt        = true
  }
}
