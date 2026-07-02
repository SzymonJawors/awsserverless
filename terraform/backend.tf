terraform {
  backend "s3" {
    bucket       = "mybucketfortheappjawor"
    key          = "prod/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}