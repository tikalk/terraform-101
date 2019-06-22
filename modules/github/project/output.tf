output "info" {
  value = {
    name = "${github_organization_project.app_project.name}"
    url = "${github_organization_project.app_project.url}"
  }
}
