variable "env" {
  default = "dev"
}

variable "region" {
  description = "Your AWS region name e.g eu-west-1"
}

variable "profile" {
  description = "Your AWS profile name"
}

variable "bucket" {
  description = "Terraform state s3 bucket"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for s3 state"
  # default = "TerraformStatelock"
}

variable "operators" {
  default = [
    "haggai_tikal",
     "salo_tikal",
    ]
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

################
## EKS
################

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      user_arn = "arn:aws:iam::514098219403:user/haggai_tikal"
      username = "haggai_tikal"
      group    = "system:masters"
    },
    {
      user_arn = "arn:aws:iam::514098219403:user/devops"
      username = "devops"
      group    = "system:masters"
    },
  ]
}

variable "map_roles" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      user_arn = "arn:aws:iam::514098219403:group/Admgroup"
      username = "Admgroup"
      group    = "system:masters"
    },
  ]
}

variable "cluster_name" {
  default = "poc1"
}

variable "cluster_tags" {
  default = {
    GitlabRepo = "infra"
    GitlabOrg  = "insport"
    Workspace  = "prd-eu"
  }
}
variable "cluster_version" {
  default = "1.12"
}

variable "kubeconfig_output_path" {
  default = "../"
}
