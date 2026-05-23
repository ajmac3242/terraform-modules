variables {
  cluster_name = "test-eks"
  subnet_ids   = ["subnet-12345", "subnet-67890"]
  kms_key_arn  = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  tags = {
    environment = "test"
    owner       = "test-owner"
    project     = "test-project"
    cost_center = "test-cc"
  }
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

run "valid_eks_creation" {
  command = plan

  assert {
    condition     = aws_eks_cluster.this.name == var.cluster_name
    error_message = "EKS cluster name does not match expected value"
  }

  assert {
    condition     = length(aws_eks_cluster.this.encryption_config) == 1
    error_message = "Encryption config should be present"
  }

  assert {
    condition     = aws_eks_cluster.this.encryption_config[0].provider[0].key_arn == var.kms_key_arn
    error_message = "Encryption CMK ARN does not match expected value"
  }

  assert {
    condition     = aws_eks_cluster.this.tags["environment"] == "test" && aws_eks_cluster.this.tags["owner"] == "test-owner" && aws_eks_cluster.this.tags["project"] == "test-project" && aws_eks_cluster.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on EKS cluster"
  }
}
