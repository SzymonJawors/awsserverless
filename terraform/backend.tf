terraform {
  backend "s3" {
    bucket = "mybucketfortheappjawor"
    key = "prod/terraform.tfstate"
    region = "eu-north-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}