provider "aws" {
  region = "eu-west-1"
}

locals {
  environment_name = "${var.branch == "master" ? "prod" :
                        var.branch == "develop" ? "beta" : var.branch}"

  environment_host = "${local.environment_name == "prod" ? "chrisprie.st" :
                        local.environment_name == "beta" ? "beta.chrisprie.st" : format("%s.environments.chrisprie.st", local.environment_name)}"
}

module "front_end" {
  source = "front_end"

  website_host        = "${local.environment_host}"
  hosted_zone_id      = "ZN01MVFLONN4L"                                                                       //chrisprie.st
  environment         = "${local.environment_name}"
  use_cdn             = "${local.environment_name == "prod" || local.environment_name == "beta"}"
  acm_certificate_arn = "arn:aws:acm:us-east-1:900035652496:certificate/40476f2c-2a78-4fb8-8583-0f09362f075f"
}
