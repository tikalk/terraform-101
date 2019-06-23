########################################
# Infrastructure Team, Repo, Project #
########################################


module "infra-terraform-repository" {
  source             = "../modules/github/repository"
  name               = "terraform-101"
  description        = "Terraform Workshop repository"
  allow_merge_commit = "true"
  admin_access_teams = ["${var.github_owners_team}"]
}
