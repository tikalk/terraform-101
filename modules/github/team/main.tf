resource "github_team" "team" {
  name = "${var.name}"
  privacy = "${var.privacy}"
}

resource "github_team_membership" "maintainer_members" {
  count = "${length(var.maintainer_members)}"
  team_id = "${github_team.team.id}"
  username = "${var.maintainer_members[count.index]}"
  role = "maintainer"
}

resource "github_team_membership" "members" {
  count = "${length(var.members)}"
  team_id = "${github_team.team.id}"
  username = "${var.members[count.index]}"
}
