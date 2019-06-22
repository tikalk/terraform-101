output "info" {
  value = {
    name = "${github_repository.app_repository.full_name}"
    url = "${github_repository.app_repository.git_clone_url}"
  }
}
