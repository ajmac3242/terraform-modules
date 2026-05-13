# Glue Catalog Database
resource "aws_glue_catalog_database" "this" {
  name = var.name

  tags = var.tags
}

# Glue Data Catalog Encryption Settings (Mandatory CMK)
resource "aws_glue_data_catalog_encryption_settings" "this" {
  data_catalog_encryption_settings {
    connection_password_encryption {
      return_connection_password_encrypted = true
      aws_kms_key_id                       = var.kms_key_arn
    }

    encryption_at_rest {
      catalog_encryption_mode = "SSE-KMS"
      sse_aws_kms_key_id      = var.kms_key_arn
    }
  }
}

# Glue Security Configuration (Mandatory CMK Encryption)
resource "aws_glue_security_configuration" "this" {
  name = "${var.name}-security-config"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = var.kms_key_arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn                   = var.kms_key_arn
    }

    s3_encryption {
      s3_encryption_mode = "SSE-KMS"
      kms_key_arn        = var.kms_key_arn
    }
  }
}

# Glue Crawler
resource "aws_glue_crawler" "this" {
  count = length(var.s3_targets) > 0 ? 1 : 0

  database_name          = aws_glue_catalog_database.this.name
  name                   = var.name
  role                   = var.role_arn
  security_configuration = aws_glue_security_configuration.this.name

  dynamic "s3_target" {
    for_each = var.s3_targets
    content {
      path = s3_target.value.path
    }
  }

  tags = var.tags
}

# Glue Connection (for VPC placement)
resource "aws_glue_connection" "this" {
  count = var.vpc_config != null ? 1 : 0

  name            = "${var.name}-vpc-connection"
  connection_type = "NETWORK"

  physical_connection_requirements {
    security_group_id_list = var.vpc_config.security_group_ids
    subnet_id              = var.vpc_config.subnet_ids[0]
  }

  tags = var.tags
}

# Glue Job
resource "aws_glue_job" "this" {
  count = var.command_script_location != null ? 1 : 0

  name                   = var.name
  role_arn               = var.role_arn
  glue_version           = "4.0"
  security_configuration = aws_glue_security_configuration.this.name
  connections            = var.vpc_config != null ? [aws_glue_connection.this[0].name] : null

  command {
    name            = "glueetl"
    script_location = var.command_script_location
  }

  tags = var.tags
}
