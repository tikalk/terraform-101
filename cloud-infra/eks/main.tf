terraform {
  required_version = ">= 0.11.8"
  backend "s3" {
    key = "main-vpc-eks/terraform.tfstate"
  }
}

provider "aws" {
  version = ">= 1.24.0"
  region  = "${var.region}"
  profile = "${var.profile}"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "${path.module}/../vpc/terraform.tfstate"
  }
}

# data "terraform_remote_state" "main_vpc" {
#     backend = "s3"

#   config {
#     key            = "main-vpc/terraform.tfstate"
#     bucket         = "${var.bucket}"
#     dynamodb_table = "${var.dynamodb_table}"
#     profile        = "${var.profile}"
#     region         = "${var.region}"
#   }
# }

resource "aws_key_pair" "fd19-eks" {
  key_name   = "fd19-eks"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmKmyhF8ew2V6c0ZFykWld12tKVtkg2kzJfi8whYYfF8yXHyNSmRon1saxGUCcFc+yXjD2GZq/p6TfKE/y934ukaanuQTA51G40ueV+EUPgfYL4rIiBeQ7Tkb+t/RzkwWrO6y7nst35dPmNv28EnnQucehshWybUMul6cLs+YvOOSBkLtVgWw/ZKIoVQ4DA0e4+nvtptJijW3LXWj8Zwj080WpiHuDGcg9jZegykjq8Palee0CmjN0RM7WnJKLk/pe10x5c4fB+vnn2HmoDXrYYT+3LOgFYak9TCXz5cyobN5ygSBArvOC6DIm4MwhWw/1nRyu3i1EIsiY0v+rRHfx tikal@eks-key"
}

resource "aws_security_group" "eks-workers-controlPlaneSg" {
  description = "Access to workers from within the vpc / via vpn"
  name_prefix = "all_worker_management"
  vpc_id      = "${data.terraform_remote_state.main_vpc.vpc_id}"

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

resource "null_resource" "check_requirements" {

  provisioner "local-exec" {
    command = <<EOT
      set -e
      # ansible --version
      terraform version
      jq --version
      helm version --client
      aws-iam-authenticator
EOT
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

  worker_groups = [
    {
      name                          = "infra-cpu-workloads"
      autoscaling_enabled           = true
      protect_from_scale_in         = true
      asg_desired_capacity          = 1
      asg_max_size                  = 3
      asg_min_size                  = 1
      key_name                      = "${aws_key_pair.fd19-eks.key_name}"
      instance_type                 = "t3.large"
      root_volume_size              = 200
      subnets                       = "${join(",", data.terraform_remote_state.main_vpc.private_subnets)}"
      # kubelet_extra_args            = "--register-with-taints=key=value:NoSchedule --node-labels=workload-type=infra-workload"	
      bootstrap_extra_args          = "--enable-docker-bridge true"
    },
    {
      name                          = "standard-cpu-workload"
      autoscaling_enabled           = true
      asg_desired_capacity          = 0
      asg_max_size                  = 3
      asg_min_size                  = 0
      root_volume_size              = 200
      key_name                      = "${aws_key_pair.fd19-eks.key_name}"
      instance_type                 = "t2.medium"
      subnets                       = "${join(",", data.terraform_remote_state.main_vpc.private_subnets)}"
      # kubelet_extra_args            = "--node-labels=workload-type=cpu-workload"
      bootstrap_extra_args          = "--enable-docker-bridge true"
    },
      {
      name                          = "standard-gpu-workload"
      autoscaling_enabled           = true
      asg_desired_capacity          = 0
      asg_max_size                  = 3
      asg_min_size                  = 0
      root_volume_size              = 300
      ami_id                        = "ami-03ac091e67b6d51d5"
      key_name                      = "${aws_key_pair.fd19-eks.key_name}"
      instance_type                 = "g3.4xlarge"
      subnets                       = "${join(",", data.terraform_remote_state.main_vpc.private_subnets)}"
      # kubelet_extra_args            = "--register-with-taints=key=value:NoSchedule --node-labels=workload-type=gpu-workload"	
      bootstrap_extra_args          = "--enable-docker-bridge true"
    },
  ]
}

module "eks" {
  version                              = "v3.0.0"
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = "${var.cluster_name}"
  cluster_version                      = "${var.cluster_version}"
  subnets                              = ["${data.terraform_remote_state.main_vpc.private_subnets}"]
  tags                                 = "${var.cluster_tags}"
  vpc_id                               = "${data.terraform_remote_state.main_vpc.vpc_id}"
  worker_groups                        = "${local.worker_groups}"
  worker_group_count                   = "3"
  worker_additional_security_group_ids = ["${aws_security_group.eks-workers-controlPlaneSg.id}"]
  map_users                            = "${var.map_users}"
  map_roles                            = "${var.map_roles}"


}
