
# KMS (S3 arthifact)

resource "aws_kms_key" "key_s3_artifact" {
  description = "ECS pipeline artifact Key"
  is_enabled  = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })
  key_usage = "ENCRYPT_DECRYPT"
  tags = {
    Name = "s3_artifact-artifact-key"
  }
}

resource "aws_kms_alias" "key_alias_s3_artifact" {
  name          = "alias/ecs-pipeline-artifact-key"
  target_key_id = aws_kms_key.key_s3_artifact.key_id
}