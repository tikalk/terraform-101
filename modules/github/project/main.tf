resource "github_organization_project" "app_project" {
  name = "${title(var.name)} Project"
}

resource "github_project_column" "app_project_backlog_column" {
  count = "${length(var.columns)}"
  project_id = "${github_organization_project.app_project.id}"
  name       = "${var.columns[count.index]}"
}
