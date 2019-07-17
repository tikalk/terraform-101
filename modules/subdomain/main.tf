# aws + provider + local state (for now)
terraform {
  required_version = ">= 0.11.13"
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "aws_route53_zone" "root" {
  name = "${var.root_domain_name}"
}

resource "aws_route53_zone" "main" {
  name          = "${var.sub_domain_name}.${var.root_domain_name}"
  force_destroy = "false"
  comment       = "Zone for ${var.sub_domain_name}.${var.root_domain_name}"
}

resource "aws_route53_record" "group-NS" {
  zone_id = "${data.aws_route53_zone.root.id}"
  name    = "${var.sub_domain_name}.${var.root_domain_name}"
  type    = "NS"
  ttl     = "900"

  records = [
    "${aws_route53_zone.main.name_servers.0}",
    "${aws_route53_zone.main.name_servers.1}",
    "${aws_route53_zone.main.name_servers.2}",
    "${aws_route53_zone.main.name_servers.3}",
  ]

  allow_overwrite = true
}
