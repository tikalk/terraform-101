###############
# Pull Access #
###############
data "github_team" "pull_access_teams" {
  count = "${length(var.pull_access_teams)}"
  slug = "${var.pull_access_teams[count.index]}"
}

data "github_user" "pull_access_users" {
  count = "${length(var.pull_access_users)}"
  username = "${var.pull_access_users[count.index]}"
}

resource "github_team_repository" "pull_access_teams" {
  count = "${length(data.github_team.pull_access_teams.*.id)}"
  team_id    = "${element(data.github_team.pull_access_teams.*.id, count.index)}"
  repository = "${github_repository.app_repository.name}"
  permission = "pull"
}

resource "github_repository_collaborator" "pull_access_users" {
  count = "${length(data.github_user.pull_access_users.*.login)}"
  repository = "${github_repository.app_repository.name}"
  username   = "${element(data.github_user.pull_access_users.*.login, count.index)}"
  permission = "pull"
}

###############
# Push Access #
###############

data "github_team" "push_access_teams" {
  count = "${length(var.push_access_teams)}"
  slug = "${var.push_access_teams[count.index]}"
}

data "github_user" "push_access_users" {
  count = "${length(var.push_access_users)}"
  username = "${var.push_access_users[count.index]}"
}

resource "github_team_repository" "push_access_teams" {
  count = "${length(data.github_team.push_access_teams.*.id)}"
  team_id    = "${element(data.github_team.push_access_teams.*.id, count.index)}"
  repository = "${github_repository.app_repository.name}"
  permission = "push"
}

resource "github_repository_collaborator" "push_access_users" {
  count = "${length(data.github_user.push_access_users.*.login)}"
  repository = "${github_repository.app_repository.name}"
  username   = "${element(data.github_user.push_access_users.*.login, count.index)}"
  permission = "push"
}

################
# Admin Access #
################
data "github_team" "admin_access_teams" {
  count = "${length(var.admin_access_teams)}"
  slug = "${var.admin_access_teams[count.index]}"
}

data "github_user" "admin_access_users" {
  count = "${length(var.admin_access_users)}"
  username = "${var.admin_access_users[count.index]}"
}

resource "github_team_repository" "admin_access_teams" {
  count = "${length(data.github_team.admin_access_teams.*.id)}"
  team_id    = "${element(data.github_team.admin_access_teams.*.id, count.index)}"
  repository = "${github_repository.app_repository.name}"
  permission = "admin"
}

resource "github_repository_collaborator" "admin_access_users" {
  count = "${length(data.github_user.admin_access_users.*.login)}"
  repository = "${github_repository.app_repository.name}"
  username   = "${element(data.github_user.admin_access_users.*.login, count.index)}"
  permission = "admin"
}