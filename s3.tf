resource "aws_s3_bucket" "bucket_artifacts" {
  bucket = "ecs-pipeline-artifacts-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "ecs-pipeline-artifacts-${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_artifacts_encryption" {
  bucket = aws_s3_bucket.bucket_artifacts.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.key_s3_artifact.arn
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_artifacts" {
  bucket = aws_s3_bucket.bucket_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "bucket_policy_artifacts" {
  bucket = aws_s3_bucket.bucket_artifacts.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowSSLRequestsOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.bucket_artifacts.arn,
          "${aws_s3_bucket.bucket_artifacts.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}