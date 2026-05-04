terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.71, < 7.0" # Required for aws_ec2_instance_metadata_defaults
    }
  }
}
