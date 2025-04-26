variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The AWS region where the resources will be provisioned"
}

variable "tags" {
  type = map(string)
  default = {
    Managedby = "Terraform"
  }
  description = "Tags to be applied to all resources"
}

variable "ecr_repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
  }))

  default = [
    {
      name                 = "studying/dev/backend"
      image_tag_mutability = "MUTABLE"
    }
  ]
}

variable "iam_config" {
  description = "Configuração de nomes para IAM Role e Policy"
  type = object({
    role_name   = string
    policy_name = string
  })
  default = {
    role_name   = "StudyingGitHubActionsRole"
    policy_name = "StudyingGitHubActionsPolicy"
  }
}
