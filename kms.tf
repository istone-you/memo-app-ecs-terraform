
# KMS (Arthifact S3)

resource "aws_kms_key" "key_s3_artifact" {
  description = "ECS pipeline artifact Key"
  is_enabled  = true
  policy      = data.aws_iam_policy_document.key_s3_artifact.json
  key_usage   = "ENCRYPT_DECRYPT"
  tags = {
    Name = "ecs-pipeline-artifact-key"
  }
}

resource "aws_kms_alias" "key_alias_s3_artifact" {
  name          = "alias/ecs-pipeline-artifact-key"
  target_key_id = aws_kms_key.key_s3_artifact.key_id
}

data "aws_iam_policy_document" "key_s3_artifact" {
  version = "2012-10-17"
  # デフォルトキーポリシー
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
  # OACで必要なキーポリシー
  statement {
    sid    = "AllowCloudFrontServicePrincipalSSE-KMS"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.mern.arn]
    }
  }
}
