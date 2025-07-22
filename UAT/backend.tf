terraform {
  backend "s3" {

    bucket         = "saffire-uat-app-bucket"
    key            = "uat/terraform.tfstate"         # Use a unique path per environment
    region         = "us-west-2"
    #dynamodb_table = "saffire-uat-app-db"
    encrypt        = true
  }
}

