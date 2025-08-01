terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

#variable "TFC_AWS_RUN_ROLE_ARN" {
#  type        = string
#  description = "AWS Role ARN to assume for Terraform operations"
#}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "SSO_terraform"
  #assume_role {
  #  role_arn = var.TFC_AWS_RUN_ROLE_ARN
  #}
}
provider "aws" {
  alias   = "virginia" # us-east-1（CloudFront用）
  region  = "us-east-1"
  profile = "SSO_terraform"
  #assume_role {
  #  role_arn = var.TFC_AWS_RUN_ROLE_ARN
  #}
}
