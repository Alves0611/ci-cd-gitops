resource "aws_iam_role" "github" {
  name = var.iam_config.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRoleWithWebIdentity"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:Alves0611/ci-cd-gitops:*"
        }
      }
    }]
  })
}

data "aws_iam_policy_document" "github" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = aws_ecr_repository.this[*].arn
  }
}

resource "aws_iam_policy" "pipeline" {
  name   = var.iam_config.policy_name
  policy = data.aws_iam_policy_document.github.json
}

resource "aws_iam_role_policy_attachment" "github_pipeline" {
  policy_arn = aws_iam_policy.pipeline.arn
  role       = aws_iam_role.github.name
}
