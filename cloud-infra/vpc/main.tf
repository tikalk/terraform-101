# terraform {
#   required_version = "0.11.14"
#   backend "s3" {
#     key = "main-vpc/terraform.tfstate"
#   }
# }

provider "aws" {
  version = ">= 1.24.0"
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "aws_availability_zones" "available" {}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "FD19-vpc"
  cidr = "10.0.0.0/16"

  azs                 = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_tags = "${local.private_subnet_tags}"
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_tags  = "${local.public_subnet_tags}"

  enable_dns_hostnames    = true
  enable_nat_gateway      = true

  tags = "${merge(local.default_vpc_tags)}"
}

