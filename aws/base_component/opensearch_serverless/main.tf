resource "aws_opensearchserverless_security_policy" "encryption" {
  name        = "${var.name}-encryption"
  type        = "encryption"
  description = "Encryption policy for ${var.name} collection"
  policy = jsonencode({
    Rules = [
      {
        ResourceType = "collection"
        Resource     = ["collection/${var.name}"]
      }
    ]
    KmsKeyArn = var.kms_key_arn
  })
}

resource "aws_opensearchserverless_security_policy" "network" {
  name        = "${var.name}-network"
  type        = "network"
  description = "Network policy for ${var.name} collection"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.name}"]
        },
        {
          ResourceType = "dashboard"
          Resource     = ["collection/${var.name}"]
        }
      ]
      AllowFromPublic    = false
      SourceVPCEndpoints = var.vpc_endpoint_ids
    }
  ])
}

resource "aws_opensearchserverless_access_policy" "data" {
  name        = "${var.name}-access"
  type        = "data"
  description = "Data access policy for ${var.name} collection"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/${var.name}"]
          Permission = [
            "aoss:CreateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DescribeCollectionItems"
          ]
        },
        {
          ResourceType = "index"
          Resource     = ["index/${var.name}/*"]
          Permission = [
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument"
          ]
        }
      ]
      Principal = var.data_access_principals
    }
  ])
}

resource "aws_opensearchserverless_collection" "this" {
  name        = var.name
  type        = "VECTORSEARCH"
  description = "OpenSearch Serverless collection for ${var.name}"

  # Encryption policy must exist before collection creation to be applied
  depends_on = [aws_opensearchserverless_security_policy.encryption]

  tags = var.tags
}

# Data source to retrieve collection group details, including generation
data "aws_opensearchserverless_collection_group" "this" {
  name = aws_opensearchserverless_collection.this.collection_group_name
}
