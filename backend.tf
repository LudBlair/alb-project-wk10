terraform {
  backend "s3" {
    bucket  = "lblair-alb-bucket"
    key     = "alb/terraform.state"
    region  = "us-east-1"
    encrypt = true
  }
}