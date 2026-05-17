output "collection_id" {
  description = "The unique identifier of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.id
}

output "collection_arn" {
  description = "The Amazon Resource Name (ARN) of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.arn
}

output "collection_endpoint" {
  description = "The endpoint of the OpenSearch Serverless collection"
  value       = aws_opensearchserverless_collection.this.collection_endpoint
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_opensearchserverless_collection.this.tags_all
}
