terraform {
  backend "s3" {
    bucket         = "saffire-uat-app-bucket"
    key            = "prod/terraform.tfstate"         # Use a unique path per environment
    region         = "us-west-2"
    #dynamodb_table = "saffire-prod-app-db"
    encrypt        = true
  }
}

data "aws_iam_policy_document" "s3_permissions" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::saffire-uat-app-bucket/prod/terraform.tfstate",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::saffire-uat-app-bucket",
    ]
  }
}

