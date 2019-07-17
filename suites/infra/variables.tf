variable "vpc_cidr_block" {
  type = "string"
}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

# variable "cluster_tags" {
#   type = "map"
# }

# variable "database_subnets" {}

# EKS
//variable "cluster_name" {}

variable "cluster_version" {}
variable "assumed_role_admin_group" {}

variable "env" {
  default = "dev"
}

variable "region" {
  description = "The AWS region to use"
}

variable "vendor_name" {
  description = "Usually the org/company name"
  default     = "tikal"
}

variable "profile" {
  description = "The AWS profile to use"
}

variable "bucket" {
  description = "Terraform state s3 bucket"
}

variable "dynamodb_table" {
  description = "Terraform statelock DynamoDB table"
}

variable "operators" {
  type        = "list"
  description = "List of IAM users to grant access to state"
}

variable "primary_domain" {
  description = "Domain name to use"
}

variable "distribute_via_keybase" {
  description = "copy useing keybase cli true / false"
  type        = "string"
}

variable "keybase_user" {
  description = "The keybase username to use to encrypt and share gpg keys"
  type        = "string"
}




variable "map_users" {
  type = "list"
}

variable "worker_groups" {
  type = "list"
}

variable "cluster_tags" {
  type = "list"
}
