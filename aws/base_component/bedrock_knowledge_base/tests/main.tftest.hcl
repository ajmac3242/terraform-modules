variables {
  name                = "test-kb"
  aws_account_id      = "123456789012"
  embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v1"
  storage_type        = "OPENSEARCH_SERVERLESS"
  opensearch_serverless_configuration = {
    collection_arn    = "arn:aws:aoss:us-east-1:123456789012:collection/test-collection"
    vector_index_name = "test-index"
    vector_field      = "vector"
    text_field        = "text"
    metadata_field    = "metadata"
  }
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

run "valid_kb_creation" {
  command = plan

  assert {
    condition     = aws_bedrockagent_knowledge_base.this.name == var.name
    error_message = "Knowledge base name does not match expected value"
  }

  assert {
    condition     = aws_bedrockagent_knowledge_base.this.knowledge_base_configuration[0].vector_knowledge_base_configuration[0].embedding_model_arn == var.embedding_model_arn
    error_message = "Embedding model ARN does not match expected value"
  }

  assert {
    condition     = aws_bedrockagent_knowledge_base.this.tags["environment"] == "test" && aws_bedrockagent_knowledge_base.this.tags["owner"] == "test-owner" && aws_bedrockagent_knowledge_base.this.tags["project"] == "test-project" && aws_bedrockagent_knowledge_base.this.tags["cost_center"] == "test-cc"
    error_message = "Mandatory tags are missing or incorrect on Knowledge Base"
  }

}
