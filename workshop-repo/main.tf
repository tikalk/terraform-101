########################################
# Infrastructure Team, Repo, Project #
########################################


module "infra-terraform-repository" {
  source             = "../modules/github/repository"
  name               = "terraform-101"
  description        = "Terraform Workshop repository"
  admin_access_teams = ["${var.github_owners_team}"]
}
