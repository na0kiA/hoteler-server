data "aws_caller_identity" "self" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "current" {}

data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket = "na0kia-tfstate"
    key    = "hoteler-infra/hoteler_v1.3.9.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "log_alb" {
  backend = "s3"

  config = {
    bucket = "na0kia-tfstate"
    key    = "hoteler-infra/hoteler_v1.3.9.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "lovehoteler_com" {
  backend = "s3"

  config = {
    bucket = "na0kia-tfstate"
    key    = "hoteler-infra/hoteler_v1.3.9.tfstate"
    region = "ap-northeast-1"
  }
}