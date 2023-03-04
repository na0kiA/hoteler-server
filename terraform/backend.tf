terraform {
  backend "s3" {
    bucket = "shonansurvivors-tfstate"
    key    = "hoteler/hoteler_v1.0.0.tfstate"
    region = "ap-northeast-1"
  }
}