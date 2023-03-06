terraform {
  backend "s3" {
    bucket = "na0kia-tfstate"
    key    = "hoteler-infra/cicd/app_hoteler/hoteler_v1.3.9.tfstate"
    region = "ap-northeast-1"
  }
}