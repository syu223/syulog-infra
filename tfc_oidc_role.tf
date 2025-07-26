# 1. OIDC Provider

resource "aws_iam_openid_connect_provider" "tfc" {
  url = "https://app.terraform.io"

  client_id_list = ["aws"]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0a2e0f9f5"]  # 固定Thumbprint（現時点）

  tags = {
    Name = "TerraformCloudOIDC"
  }
}
# 2. IAM Role
resource "aws_iam_role" "role_tfc_access" {
  name = "tfc-workspace-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.tfc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "app.terraform.io:aud" = "aws"
            "app.terraform.io:sub" = "organization:<組織名>:workspace:<Workspace名>"
          }
        }
      }
    ]
  })
}
# 3. IAM ポリシーアタッチ（AdministratorAccess）
resource "aws_iam_role_policy_attachment" "attachment_tfc_access" {
  role       = aws_iam_role.role_tfc_access.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
