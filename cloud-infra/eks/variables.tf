variable "env" {
  default = "dev"
}

variable "region" {
    default = "eu-west-1"
}

variable "profile" {
    default = "intel-sport"
}

variable "bucket" {
  description = "Terraform state s3 bucket"
  default     = "intel-sport-terra-kops-state-new"
}

variable "dynamodb_table" {
  default = "TerraformStatelock"
}

variable "operators" {
  default = [
    "haggai_tikal",
     "salo_tikal",
    ]
}

variable "lustre_instance_count" {
    default = 3
}
variable "haggai_home_ip" {
  default = "82.166.134.98/32"
}
variable "intel_cidr" {
  default = "134.191.232.0/21"
}
variable "salo_home_ip" {
  default = "80.230.224.0/22"
}
variable "primary_domain" {
  default = "fd19.tikal.io"
}

locals {
public_subnet_tags = "${merge(
    map("SubnetType", "Utility"),
    map("kubernetes.io/cluster/poc-1.fd19.tikal.io", "shared"),
    map("kubernetes.io/role/elb", "1"),
  )}" 
private_subnet_tags = 
  "${merge(
    map("SubnetType", "Private"),
    map("kubernetes.io/cluster/poc1","shared"),
    map("kubernetes.io/cluster/poc-1.fd19.tikal.io", "shared"),
    map("kubernetes.io/role/internal-elb", "1"),
  )}" 

default_vpc_tags = 
    "${merge(
      map("kubernetes.io/cluster/poc1","shared"),
      map("Terraform","true"),
      map("Environment","FD19-dev"),
      map("Owner","Tikal-Demo-Do-Not-Delete"),
      )}"
}
###########
## Bastion
###########

variable "docker_version" {
  default = "17.03.3~ce-0~ubuntu-xenial"
  description = "passed as user_data to ec2 hosts"
}

################
## EKS
################

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  # default = [
  #   {
  #     user_arn = "arn:aws:iam::514098219403:user/haggai_tikal"
  #     username = "haggai_tikal"
  #     group    = "system:masters"
  #   },
  #   {
  #     user_arn = "arn:aws:iam::514098219403:user/devops"
  #     username = "devops"
  #     group    = "system:masters"
  #   },
  # ]
}

# variable "map_roles" {
#   description = "Additional IAM users to add to the aws-auth configmap."
#   type        = "list"

#   default = [
#     {
#       user_arn = "arn:aws:iam::514098219403:group/Admgroup"
#       username = "Admgroup"
#       group    = "system:masters"
#     },
#   ]
# }

variable "cluster_name" {
  default = "poc1"
}

variable "cluster_tags" {
  default = {
    GitlabRepo = "infra"
    GitlabOrg  = "tikal-workshops"
    Workspace  = "prd-eu"
  }
}
variable "cluster_version" {
  default = "1.12"
}

variable "kubeconfig_output_path" {
  default = "../"
}

variable "terraform_version" {
  default = "0.11.13"
}
