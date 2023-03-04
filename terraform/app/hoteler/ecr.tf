module "nginx" {
  source = "../../modules/ecr"

  name = "${local.service_name}-nginx"
}

module "rails" {
  source = "../../modules/ecr"

  name = "${local.service_name}-rails"
}