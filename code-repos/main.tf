########################################
# Infrastructure Team, Repo, Project #
########################################
module "infra-team" {
  source             = "../modules/github/team"
  name               = "Infrastructure Team"
  maintainer_members = ["hagzag"]
}

module "infra-terraform-repository" {
  source             = "../modules/github/repository"
  name               = "infra-terraform"
  description        = "Terraform Infrastructure-as-a-Code"
  admin_access_teams = ["${module.infra-team.name}"]
}

module "infra-helm-repository" {
  source             = "../modules/github/repository"
  name               = "infra-helm-charts"
  description        = "Helm Charts Repository"
  admin_access_teams = ["${module.infra-team.name}"]
}

