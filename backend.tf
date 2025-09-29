terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-dr"
    key    = "multi-region-dr/terraform.tfstate"
    region = "us-east-1"
  }
}
