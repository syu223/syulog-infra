 
terraform {
  required_version = ">= 1.12.0, < 2.0.0"
  
  cloud {
    organization = "syu-terraform"

    workspaces {
      name = "syulog"
    }
  }
}

