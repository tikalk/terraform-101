resource "github_repository" "app_repository" {
  name = "${var.name}"
  description = "${var.description}"
  private = "${var.private}"
  auto_init = "${var.auto_init}"
  allow_merge_commit = "${var.allow_merge_commit}"
}

resource "github_branch_protection" "app_repository_protection" {
  repository = "${github_repository.app_repository.name}"
  branch = "master"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    dismissal_users = [ "${data.github_user.push_access_users.*.login}" ]
    dismissal_teams = [ "${data.github_team.push_access_teams.*.slug}" ]
  }

  restrictions {
    users = [ "${data.github_user.push_access_users.*.login}" ]
    teams = [ "${data.github_team.push_access_teams.*.slug}" ]
  }
}
