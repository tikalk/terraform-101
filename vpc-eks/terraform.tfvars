# state + AWS specific
profile = "tikal"

vendor_name = "tikal"

region = "eu-central-1"

bucket = "tikal-fuse-terraform-state"

dynamodb_table = "TerraformFuseStatelock"

primary_domain = "fuse.tikal.io"

distribute_via_keybase = 0

# replace with jenkins soon (keybase_user)
keybase_user = "hagzag" 



# cluster_generic config

assumed_role_admin_group = "Admins"

cluster_version = "1.13"

private_subnets = ["172.31.48.0/20", "172.31.64.0/20", "172.31.80.0/20"]

public_subnets = ["172.31.0.0/20", "172.31.16.0/20", "172.31.32.0/20"]

# database_subnets = ["172.31.96.0/20", "172.31.112.0/20", "172.31.128.0/20"]
vpc_cidr_block = "172.31.0.0/16"

operators = [
  "chaos_bot",
  "hagzag@tikalk.com",
  "itai.or",
  "itai@tikalk.com",
]



map_users = [
    {
      user_arn = "arn:aws:iam::xxxxxxxxxxx:user/foo"
      username = "foo"
      group    = "system:masters"
    },
  ]

cluster_tags = [
  {
    GithubRepo = "fuse-${terraform.workspace}"
    GithubOrg  = "${var.vendor_name}"
    Workspace  = "${terraform.workspace}"
  },
]

worker_groups = [
  {
    name                  = "k8s-workers"
    kubelet_extra_args    = "--node-labels=eks_worker_group=blue"
    autoscaling_enabled   = true
    protect_from_scale_in = true
    asg_desired_capacity  = "1"
    asg_max_size          = "9"
    asg_min_size          = "1"

    # target_group_arns     = "${local.target_group_arns}"
    root_volume_size = "48"
    instance_type    = "m4.large"
    key_name         = "${module.ssh_key_pair.key_name}"
  }
]