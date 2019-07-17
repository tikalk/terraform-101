terraform {
  required_version = ">= 0.11.13"
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
  version = "2.17.0"
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}
