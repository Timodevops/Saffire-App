terraform {
  backend "s3" {
    bucket         = "saffire-dev-app-bucket"
    key            = "dev/terraform.tfstate"         # Use a unique path per environment
    region         = "us-west-2"
    #dynamodb_table = "saffire-dev-app-db"
    encrypt        = true
  }
}