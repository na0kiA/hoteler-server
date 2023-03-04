terraform {
  backend "s3" {
    bucket = "na0kia-tfstate"
    key    = "hoteler-infra/app/hoteler_v1.3.9.tfstate"
    region = "ap-northeast-1"
  }
}