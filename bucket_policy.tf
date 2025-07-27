
# IAM Policyドキュメントの作成
data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.private.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.origin-distribution.arn]
    }
  }
}

# バケットポリシーを作成
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.private.id
  policy = data.aws_iam_policy_document.allow_cloudfront.json
}

