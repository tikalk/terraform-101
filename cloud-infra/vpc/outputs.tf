output "public_zone_id" {
  value = "${data.aws_route53_zone.primary.id}"
}
output "current_vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${module.vpc.private_subnets_cidr_blocks}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${module.vpc.public_subnets_cidr_blocks}"]
}


output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "current_vpc_cidr" {
  value = "${module.vpc.vpc_cidr_block}"
}
output "availability_zones" {
  value = "${data.aws_availability_zones.available.names}"
}
output "master_zones" {
  value = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}",
  ]
}
output "node_zones" {
  value = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}",
  ]
}

