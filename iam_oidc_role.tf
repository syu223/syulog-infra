# 1. OIDC Provider

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98c6a67b5c1b4fefb9b6f2f432d5b9c0"]
  tags = {
    Name = "GitHubActionsOIDC"
  }
}

# 2. IAM Role
resource "aws_iam_role" "github_oidc_role" {
  name = "github-terraform-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:syu223/syulog-infra:ref:refs/heads/*"
          },
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}
# 3. IAM ポリシーアタッチ（AdministratorAccess）
resource "aws_iam_role_policy_attachment" "attach_github_admin" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
