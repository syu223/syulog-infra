terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "SSO_terraform"
}
provider "aws" {
  alias   = "virginia" # us-east-1（CloudFront用）
  region  = "us-east-1"
  profile = "SSO_terraform"
}

