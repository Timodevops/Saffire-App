terraform {
  backend "s3" {
    bucket         = "saffire-prod-app-bucket"
    key            = "prod/terraform.tfstate" # Use a unique path per environment
    region         = "us-west-2"
    dynamodb_table = "saffire-prod-app-db"
    encrypt        = true
  }
}
