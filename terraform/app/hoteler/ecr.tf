module "nginx" {
  source = "../../modules/ecr"

  name = "${local.service_name}-nginx"
}

module "ruby" {
  source = "../../modules/ecr"

  name = "${local.service_name}-ruby"
}