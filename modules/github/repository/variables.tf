variable "name" {
  type = "string"
}

variable "description" {
  type = "string"
}

variable "private" {
  default = false
}

variable "auto_init" {
  default = true
}

variable "pull_access_teams" {
  type = "list"
  default = []
}

variable "push_access_teams" {
  type = "list"
  default = []
}

variable "admin_access_teams" {
  type = "list"
  default = []
}

variable "pull_access_users" {
  type = "list"
  default = []
}

variable "push_access_users" {
  type = "list"
  default = []
}

variable "admin_access_users" {
  type = "list"
  default = []
}

