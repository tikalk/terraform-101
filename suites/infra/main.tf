terraform {}

module "iam_user" {
  source = "../../modules/iam-user"

  name          = "${terraform.workspace}"
  force_destroy = false

  # User "test" has uploaded his public key here - https://keybase.io/hagzag/pgp_keys.asc
  # pgp_key = "keybase:${var.keybase_user}"

  password_reset_required = true

  # SSH public key
  upload_iam_user_ssh_key = true

  ssh_public_key = "${module.ssh_key_pair.public_key}"
}


module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=0.11/master"
  namespace             = "fuse"
  stage                 = "dev"
  name                  = "${terraform.workspace}"
  ssh_public_key_path   = "./secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}

/** 
 * vpc
 */
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.55.0"
  name    = "${terraform.workspace}-vpc"
  cidr    = "${var.vpc_cidr_block}"

  azs = [
    "${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}",
  ]

  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"

  # database_subnets     = "${var.database_subnets}"
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  # reuse_nat_ips        = true
  # external_nat_ip_ids  = ["${aws_eip.nat_gw.id}"]

  tags = {
    "kubernetes.io/cluster/${terraform.workspace}" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${terraform.workspace}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${terraform.workspace}" = "shared"
    "kubernetes.io/role/internal-elb"              = "true"
  }
}
resource "aws_security_group" "eks-workers-controlPlaneSg" {
  description = "Access to workers from within the vpc / via vpn"
  name_prefix = "all_worker_management"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

locals {
  # the commented out worker group list below shows an example of how to define
  # multiple worker groups of differing configurations
  kubeconfig_aws_authenticator_env_variables = [
    {
      AWS_PROFILE = "${var.profile}"
    },
  ]
}
module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "4.0.2"
  cluster_name                         = "${terraform.workspace}"
  cluster_version                      = "${var.cluster_version}"
  subnets                              = ["${module.vpc.private_subnets}"]
  tags                                 = "${var.cluster_tags}"
  vpc_id                               = "${module.vpc.vpc_id}"
  worker_groups                        = ["${var.worker_groups}"]
  worker_group_count                   = "1"
  worker_additional_security_group_ids = ["${aws_security_group.eks-workers-controlPlaneSg.id}"]

  map_users = "${concat(var.map_users, list(map("user_arn", module.iam_user.this_iam_user_arn,
                                                  "username", module.iam_user.this_iam_user_name,
                                                  "group", "system:masters")))}"

  map_users_count        = "${length(var.map_users)+1}"
  cluster_create_timeout = "20m"
  config_output_path     = "./"
}

resource "null_resource" "eks-predestroy" {
  provisioner "local-exec" {
    when = "destroy"

    interpreter = ["/bin/bash", "-c"]

    command = <<CMD
ASGName=$(aws autoscaling describe-auto-scaling-groups | grep "${terraform.workspace}" -A 100 -B 100 | grep AutoScalingGroupName | tr -d '" ,' | cut -f2 -d ":")

for asg in $ASGName; do
    InstanceID=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name "$asg" | grep InstanceId | tr -d '" ,' | cut -f2 -d ":")
    for instance in $InstanceID; do
        aws autoscaling set-instance-protection --instance-ids "$instance" --auto-scaling-group-name "$asg" --no-protected-from-scale-in
    done
done
CMD
  }
}
