variable "name" {
  type = "string"
}

variable "columns" {
  type = "list"
  default = [ "Backlog", "Todo", "In Progress", "Verfied", "Done" ]
}
