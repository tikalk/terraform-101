# plan in HLD

## quick start

1. step 1 setup infra
1. step 2 setup apps

### 1. step 1 setup infra (k8s_infra):

* 1.1 Initilize the plan <details><summary>`terrform init`</summary>

    <p>

    ```sh
    terraform init
    Initializing modules...
    - module.subdomain
    - module.ssh_key_pair
    - module.iam_user
    - module.vpc
    - module.eks
    - module.ssh_key_pair.label

    Initializing provider plugins...

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, it is recommended to add version = "..." constraints to the
    corresponding provider blocks in configuration, with the constraint strings
    suggested below.

    * provider.tls: version = "~> 2.0"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    
    ```

    </p>

* 1.2 Create Terraform workspace as your cluster_name, `g1` in this example
    
    <p>
    
    ```
    terraform workspace new g1
    ```

    Alternatively select an existing workspace by running `terraform workspace select g1` which does all the workspace magic ...

    which should result in:

    ```sh
    Switched to workspace "g1".
    ```
    
    </p>


* 1.3 Create a plan file / or skip directly to `apply` below <details><summary>`terraform plan -out tfplan`</summary> :


    ```sh
    terraform plan -out tfplan
    Refreshing Terraform state in-memory prior to plan...
    The refreshed state will be used to calculate this plan, but will not be
    persisted to local or remote state storage.

    data.aws_region.current: Refreshing state...
    data.aws_iam_group.Admins: Refreshing state...
    data.aws_caller_identity.current: Refreshing state...
    data.aws_availability_zones.available: Refreshing state...
    data.aws_caller_identity.current: Refreshing state...
    data.aws_iam_policy_document.cluster_assume_role_policy: Refreshing state...
    data.aws_ami.eks_worker: Refreshing state...
    data.aws_iam_policy_document.workers_assume_role_policy: Refreshing state...
    data.template_file.map_roles: Refreshing state...
    data.aws_route53_zone.root: Refreshing state...

    ------------------------------------------------------------------------

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
    + create
    <= read (data resources)

    Terraform will perform the following actions:

    + aws_eip.nat_gw
        id:                                                 <computed>
        allocation_id:                                      <computed>
        association_id:                                     <computed>
        domain:                                             <computed>
        instance:                                           <computed>
        network_interface:                                  <computed>
        private_dns:                                        <computed>
        private_ip:                                         <computed>
        public_dns:                                         <computed>
        public_ip:                                          <computed>
        public_ipv4_pool:                                   <computed>
        tags.%:                                             "2"
        tags.Description:                                   "A gw for private subnets egress internet aceess"
        tags.Name:                                          "g1-vpc-nat_gw"
        vpc:                                                "true"

    + aws_security_group.eks-workers-controlPlaneSg
        id:                                                 <computed>
        arn:                                                <computed>
        description:                                        "Access to workers from within the vpc / via vpn"
        egress.#:                                           <computed>
        ingress.#:                                          "1"
        ingress.3024135210.cidr_blocks.#:                   "3"
        ingress.3024135210.cidr_blocks.0:                   "10.0.0.0/8"
        ingress.3024135210.cidr_blocks.1:                   "172.16.0.0/12"
        ingress.3024135210.cidr_blocks.2:                   "192.168.0.0/16"
        ingress.3024135210.description:                     ""
        ingress.3024135210.from_port:                       "22"
        ingress.3024135210.ipv6_cidr_blocks.#:              "0"
        ingress.3024135210.prefix_list_ids.#:               "0"
        ingress.3024135210.protocol:                        "tcp"
        ingress.3024135210.security_groups.#:               "0"
        ingress.3024135210.self:                            "false"
        ingress.3024135210.to_port:                         "22"
        name:                                               <computed>
        name_prefix:                                        "all_worker_management"
        owner_id:                                           <computed>
        revoke_rules_on_delete:                             "false"
        vpc_id:                                             "${module.vpc.vpc_id}"

    <= module.eks.data.aws_iam_policy_document.worker_autoscaling
        id:                                                 <computed>
        json:                                               <computed>
        statement.#:                                        "2"
        statement.0.actions.#:                              "5"
        statement.0.actions.1274732150:                     "autoscaling:DescribeAutoScalingGroups"
        statement.0.actions.1418764550:                     "ec2:DescribeLaunchTemplateVersions"
        statement.0.actions.2448883636:                     "autoscaling:DescribeAutoScalingInstances"
        statement.0.actions.2555065653:                     "autoscaling:DescribeLaunchConfigurations"
        statement.0.actions.3701464416:                     "autoscaling:DescribeTags"
        statement.0.effect:                                 "Allow"
        statement.0.resources.#:                            "1"
        statement.0.resources.2679715827:                   "*"
        statement.0.sid:                                    "eksWorkerAutoscalingAll"
        statement.1.actions.#:                              "3"
        statement.1.actions.1536675971:                     "autoscaling:UpdateAutoScalingGroup"
        statement.1.actions.3469696720:                     "autoscaling:TerminateInstanceInAutoScalingGroup"
        statement.1.actions.557626329:                      "autoscaling:SetDesiredCapacity"
        statement.1.condition.#:                            "2"
        statement.1.condition.1538362590.test:              "StringEquals"
        statement.1.condition.1538362590.values.#:          "1"
        statement.1.condition.1538362590.values.653127311:  "owned"
        statement.1.condition.1538362590.variable:          "autoscaling:ResourceTag/kubernetes.io/cluster/g1"
        statement.1.condition.3636405986.test:              "StringEquals"
        statement.1.condition.3636405986.values.#:          "1"
        statement.1.condition.3636405986.values.4043113848: "true"
        statement.1.condition.3636405986.variable:          "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
        statement.1.effect:                                 "Allow"
        statement.1.resources.#:                            "1"
        statement.1.resources.2679715827:                   "*"
        statement.1.sid:                                    "eksWorkerAutoscalingOwn"
        version:                                            "2012-10-17"


    <= module.eks.data.template_file.kubeconfig
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "apiVersion: v1\npreferences: {}\nkind: Config\n\nclusters:\n- cluster:\n    server: ${endpoint}\n    certificate-authority-data: ${cluster_auth_base64}\n  name: ${kubeconfig_name}\n\ncontexts:\n- context:\n    cluster: ${kubeconfig_name}\n    user: ${kubeconfig_name}\n  name: ${kubeconfig_name}\n\ncurrent-context: ${kubeconfig_name}\n\nusers:\n- name: ${kubeconfig_name}\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      command: ${aws_authenticator_command}\n      args:\n${aws_authenticator_command_args}\n${aws_authenticator_additional_args}\n${aws_authenticator_env_variables}\n"
        vars.%:                                             <computed>

    <= module.eks.data.template_file.map_users
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "    - userarn: ${user_arn}\n      username: ${username}\n      groups:\n        - ${group}\n"
        vars.%:                                             <computed>

    <= module.eks.data.template_file.userdata[0]
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "#!/bin/bash -xe\n\n# Allow user supplied pre userdata code\n${pre_userdata}\n\n# Bootstrap and join the cluster\n/etc/eks/bootstrap.sh --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args '${kubelet_extra_args}' '${cluster_name}'\n\n# Allow user supplied userdata code\n${additional_userdata}\n"
        vars.%:                                             <computed>

    <= module.eks.data.template_file.userdata[1]
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "#!/bin/bash -xe\n\n# Allow user supplied pre userdata code\n${pre_userdata}\n\n# Bootstrap and join the cluster\n/etc/eks/bootstrap.sh --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args '${kubelet_extra_args}' '${cluster_name}'\n\n# Allow user supplied userdata code\n${additional_userdata}\n"
        vars.%:                                             <computed>

    <= module.eks.data.template_file.worker_role_arns[0]
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "    - rolearn: ${worker_role_arn}\n      username: system:node:{{EC2PrivateDNSName}}\n      groups:\n        - system:bootstrappers\n        - system:nodes\n"
        vars.%:                                             <computed>

    <= module.eks.data.template_file.worker_role_arns[1]
        id:                                                 <computed>
        rendered:                                           <computed>
        template:                                           "    - rolearn: ${worker_role_arn}\n      username: system:node:{{EC2PrivateDNSName}}\n      groups:\n        - system:bootstrappers\n        - system:nodes\n"
        vars.%:                                             <computed>

    + module.eks.aws_autoscaling_group.workers[0]
        id:                                                 <computed>
        arn:                                                <computed>
        availability_zones.#:                               <computed>
        default_cooldown:                                   <computed>
        desired_capacity:                                   "0"
        enabled_metrics.#:                                  <computed>
        force_delete:                                       "false"
        health_check_grace_period:                          "300"
        health_check_type:                                  <computed>
        launch_configuration:                               "${element(aws_launch_configuration.workers.*.id, count.index)}"
        load_balancers.#:                                   <computed>
        max_size:                                           "0"
        metrics_granularity:                                "1Minute"
        min_size:                                           "0"
        name:                                               <computed>
        name_prefix:                                        "g1-k8s-blue-workers"
        placement_group:                                    "${lookup(var.worker_groups[count.index], \"placement_group\", local.workers_group_defaults[\"placement_group\"])}"
        protect_from_scale_in:                              "false"
        service_linked_role_arn:                            "${lookup(var.worker_groups[count.index], \"service_linked_role_arn\", local.workers_group_defaults[\"service_linked_role_arn\"])}"
        suspended_processes.#:                              <computed>
        tags.#:                                             <computed>
        target_group_arns.#:                                <computed>
        vpc_zone_identifier.#:                              <computed>
        wait_for_capacity_timeout:                          "10m"

    + module.eks.aws_autoscaling_group.workers[1]
        id:                                                 <computed>
        arn:                                                <computed>
        availability_zones.#:                               <computed>
        default_cooldown:                                   <computed>
        desired_capacity:                                   "0"
        enabled_metrics.#:                                  <computed>
        force_delete:                                       "false"
        health_check_grace_period:                          "300"
        health_check_type:                                  <computed>
        launch_configuration:                               "${element(aws_launch_configuration.workers.*.id, count.index)}"
        load_balancers.#:                                   <computed>
        max_size:                                           "0"
        metrics_granularity:                                "1Minute"
        min_size:                                           "0"
        name:                                               <computed>
        name_prefix:                                        "g1-k8s-green-workers"
        placement_group:                                    "${lookup(var.worker_groups[count.index], \"placement_group\", local.workers_group_defaults[\"placement_group\"])}"
        protect_from_scale_in:                              "false"
        service_linked_role_arn:                            "${lookup(var.worker_groups[count.index], \"service_linked_role_arn\", local.workers_group_defaults[\"service_linked_role_arn\"])}"
        suspended_processes.#:                              <computed>
        tags.#:                                             <computed>
        target_group_arns.#:                                <computed>
        vpc_zone_identifier.#:                              <computed>
        wait_for_capacity_timeout:                          "10m"

    + module.eks.aws_eks_cluster.this
        id:                                                 <computed>
        arn:                                                <computed>
        certificate_authority.#:                            <computed>
        created_at:                                         <computed>
        endpoint:                                           <computed>
        name:                                               "g1"
        platform_version:                                   <computed>
        role_arn:                                           "${local.cluster_iam_role_arn}"
        version:                                            "1.12"
        vpc_config.#:                                       "1"
        vpc_config.0.endpoint_private_access:               "false"
        vpc_config.0.endpoint_public_access:                "true"
        vpc_config.0.security_group_ids.#:                  <computed>
        vpc_config.0.subnet_ids.#:                          <computed>
        vpc_config.0.vpc_id:                                <computed>

    + module.eks.aws_iam_instance_profile.workers[0]
        id:                                                 <computed>
        arn:                                                <computed>
        create_date:                                        <computed>
        name:                                               <computed>
        name_prefix:                                        "g1"
        path:                                               "/"
        role:                                               "${lookup(var.worker_groups[count.index], \"iam_role_id\",  lookup(local.workers_group_defaults, \"iam_role_id\"))}"
        roles.#:                                            <computed>
        unique_id:                                          <computed>

    + module.eks.aws_iam_instance_profile.workers[1]
        id:                                                 <computed>
        arn:                                                <computed>
        create_date:                                        <computed>
        name:                                               <computed>
        name_prefix:                                        "g1"
        path:                                               "/"
        role:                                               "${lookup(var.worker_groups[count.index], \"iam_role_id\",  lookup(local.workers_group_defaults, \"iam_role_id\"))}"
        roles.#:                                            <computed>
        unique_id:                                          <computed>

    + module.eks.aws_iam_policy.worker_autoscaling
        id:                                                 <computed>
        arn:                                                <computed>
        description:                                        "EKS worker node autoscaling policy for cluster g1"
        name:                                               <computed>
        name_prefix:                                        "eks-worker-autoscaling-g1"
        path:                                               "/"
        policy:                                             "${data.aws_iam_policy_document.worker_autoscaling.json}"

    + module.eks.aws_iam_role.cluster
        id:                                                 <computed>
        arn:                                                <computed>
        assume_role_policy:                                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"EKSClusterAssumeRole\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"eks.amazonaws.com\"\n      }\n    }\n  ]\n}"
        create_date:                                        <computed>
        force_detach_policies:                              "true"
        max_session_duration:                               "3600"
        name:                                               <computed>
        name_prefix:                                        "g1"
        path:                                               "/"
        unique_id:                                          <computed>

    + module.eks.aws_iam_role.workers
        id:                                                 <computed>
        arn:                                                <computed>
        assume_role_policy:                                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"EKSWorkerAssumeRole\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      }\n    }\n  ]\n}"
        create_date:                                        <computed>
        force_detach_policies:                              "true"
        max_session_duration:                               "3600"
        name:                                               <computed>
        name_prefix:                                        "g1"
        path:                                               "/"
        unique_id:                                          <computed>

    + module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
        id:                                                 <computed>
        policy_arn:                                         "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        role:                                               "${aws_iam_role.cluster.name}"

    + module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy
        id:                                                 <computed>
        policy_arn:                                         "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
        role:                                               "${aws_iam_role.cluster.name}"

    + module.eks.aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly
        id:                                                 <computed>
        policy_arn:                                         "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        role:                                               "${aws_iam_role.workers.name}"

    + module.eks.aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy
        id:                                                 <computed>
        policy_arn:                                         "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        role:                                               "${aws_iam_role.workers.name}"

    + module.eks.aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy
        id:                                                 <computed>
        policy_arn:                                         "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        role:                                               "${aws_iam_role.workers.name}"

    + module.eks.aws_iam_role_policy_attachment.workers_autoscaling
        id:                                                 <computed>
        policy_arn:                                         "${aws_iam_policy.worker_autoscaling.arn}"
        role:                                               "${aws_iam_role.workers.name}"

    + module.eks.aws_launch_configuration.workers[0]
        id:                                                 <computed>
        associate_public_ip_address:                        "false"
        ebs_block_device.#:                                 <computed>
        ebs_optimized:                                      "false"
        enable_monitoring:                                  "false"
        iam_instance_profile:                               "${element(coalescelist(aws_iam_instance_profile.workers.*.id, data.aws_iam_instance_profile.custom_worker_group_iam_instance_profile.*.name), count.index)}"
        image_id:                                           "${lookup(var.worker_groups[count.index], \"ami_id\", local.workers_group_defaults[\"ami_id\"])}"
        instance_type:                                      "${lookup(var.worker_groups[count.index], \"instance_type\", local.workers_group_defaults[\"instance_type\"])}"
        key_name:                                           "${lookup(var.worker_groups[count.index], \"key_name\", local.workers_group_defaults[\"key_name\"])}"
        name:                                               <computed>
        name_prefix:                                        "g1-k8s-blue-workers"
        placement_tenancy:                                  "${lookup(var.worker_groups[count.index], \"placement_tenancy\", local.workers_group_defaults[\"placement_tenancy\"])}"
        root_block_device.#:                                "1"
        root_block_device.0.delete_on_termination:          "true"
        root_block_device.0.iops:                           "0"
        root_block_device.0.volume_size:                    "0"
        root_block_device.0.volume_type:                    "${lookup(var.worker_groups[count.index], \"root_volume_type\", local.workers_group_defaults[\"root_volume_type\"])}"
        security_groups.#:                                  <computed>
        spot_price:                                         "${lookup(var.worker_groups[count.index], \"spot_price\", local.workers_group_defaults[\"spot_price\"])}"
        user_data_base64:                                   "${base64encode(element(data.template_file.userdata.*.rendered, count.index))}"

    + module.eks.aws_launch_configuration.workers[1]
        id:                                                 <computed>
        associate_public_ip_address:                        "false"
        ebs_block_device.#:                                 <computed>
        ebs_optimized:                                      "false"
        enable_monitoring:                                  "false"
        iam_instance_profile:                               "${element(coalescelist(aws_iam_instance_profile.workers.*.id, data.aws_iam_instance_profile.custom_worker_group_iam_instance_profile.*.name), count.index)}"
        image_id:                                           "${lookup(var.worker_groups[count.index], \"ami_id\", local.workers_group_defaults[\"ami_id\"])}"
        instance_type:                                      "${lookup(var.worker_groups[count.index], \"instance_type\", local.workers_group_defaults[\"instance_type\"])}"
        key_name:                                           "${lookup(var.worker_groups[count.index], \"key_name\", local.workers_group_defaults[\"key_name\"])}"
        name:                                               <computed>
        name_prefix:                                        "g1-k8s-green-workers"
        placement_tenancy:                                  "${lookup(var.worker_groups[count.index], \"placement_tenancy\", local.workers_group_defaults[\"placement_tenancy\"])}"
        root_block_device.#:                                "1"
        root_block_device.0.delete_on_termination:          "true"
        root_block_device.0.iops:                           "0"
        root_block_device.0.volume_size:                    "0"
        root_block_device.0.volume_type:                    "${lookup(var.worker_groups[count.index], \"root_volume_type\", local.workers_group_defaults[\"root_volume_type\"])}"
        security_groups.#:                                  <computed>
        spot_price:                                         "${lookup(var.worker_groups[count.index], \"spot_price\", local.workers_group_defaults[\"spot_price\"])}"
        user_data_base64:                                   "${base64encode(element(data.template_file.userdata.*.rendered, count.index))}"

    + module.eks.aws_security_group.cluster
        id:                                                 <computed>
        arn:                                                <computed>
        description:                                        "EKS cluster security group."
        egress.#:                                           <computed>
        ingress.#:                                          <computed>
        name:                                               <computed>
        name_prefix:                                        "g1"
        owner_id:                                           <computed>
        revoke_rules_on_delete:                             "false"
        tags.%:                                             "4"
        tags.GithubOrg:                                     "tikal"
        tags.GithubRepo:                                    "fuse-g1"
        tags.Name:                                          "g1-eks_cluster_sg"
        tags.Workspace:                                     "g1"
        vpc_id:                                             "${var.vpc_id}"

    + module.eks.aws_security_group.workers
        id:                                                 <computed>
        arn:                                                <computed>
        description:                                        "Security group for all nodes in the cluster."
        egress.#:                                           <computed>
        ingress.#:                                          <computed>
        name:                                               <computed>
        name_prefix:                                        "g1"
        owner_id:                                           <computed>
        revoke_rules_on_delete:                             "false"
        tags.%:                                             "5"
        tags.GithubOrg:                                     "tikal"
        tags.GithubRepo:                                    "fuse-g1"
        tags.Name:                                          "g1-eks_worker_sg"
        tags.Workspace:                                     "g1"
        tags.kubernetes.io/cluster/g1:                      "owned"
        vpc_id:                                             "${var.vpc_id}"

    + module.eks.aws_security_group_rule.cluster_egress_internet
        id:                                                 <computed>
        cidr_blocks.#:                                      "1"
        cidr_blocks.0:                                      "0.0.0.0/0"
        description:                                        "Allow cluster egress access to the Internet."
        from_port:                                          "0"
        protocol:                                           "-1"
        security_group_id:                                  "${aws_security_group.cluster.id}"
        self:                                               "false"
        source_security_group_id:                           <computed>
        to_port:                                            "0"
        type:                                               "egress"

    + module.eks.aws_security_group_rule.cluster_https_worker_ingress
        id:                                                 <computed>
        description:                                        "Allow pods to communicate with the EKS cluster API."
        from_port:                                          "443"
        protocol:                                           "tcp"
        security_group_id:                                  "${aws_security_group.cluster.id}"
        self:                                               "false"
        source_security_group_id:                           "${local.worker_security_group_id}"
        to_port:                                            "443"
        type:                                               "ingress"

    + module.eks.aws_security_group_rule.workers_egress_internet
        id:                                                 <computed>
        cidr_blocks.#:                                      "1"
        cidr_blocks.0:                                      "0.0.0.0/0"
        description:                                        "Allow nodes all egress to the Internet."
        from_port:                                          "0"
        protocol:                                           "-1"
        security_group_id:                                  "${aws_security_group.workers.id}"
        self:                                               "false"
        source_security_group_id:                           <computed>
        to_port:                                            "0"
        type:                                               "egress"

    + module.eks.aws_security_group_rule.workers_ingress_cluster
        id:                                                 <computed>
        description:                                        "Allow workers pods to receive communication from the cluster control plane."
        from_port:                                          "1025"
        protocol:                                           "tcp"
        security_group_id:                                  "${aws_security_group.workers.id}"
        self:                                               "false"
        source_security_group_id:                           "${local.cluster_security_group_id}"
        to_port:                                            "65535"
        type:                                               "ingress"

    + module.eks.aws_security_group_rule.workers_ingress_cluster_https
        id:                                                 <computed>
        description:                                        "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
        from_port:                                          "443"
        protocol:                                           "tcp"
        security_group_id:                                  "${aws_security_group.workers.id}"
        self:                                               "false"
        source_security_group_id:                           "${local.cluster_security_group_id}"
        to_port:                                            "443"
        type:                                               "ingress"

    + module.eks.aws_security_group_rule.workers_ingress_self
        id:                                                 <computed>
        description:                                        "Allow node to communicate with each other."
        from_port:                                          "0"
        protocol:                                           "-1"
        security_group_id:                                  "${aws_security_group.workers.id}"
        self:                                               "false"
        source_security_group_id:                           "${aws_security_group.workers.id}"
        to_port:                                            "65535"
        type:                                               "ingress"

    + module.eks.local_file.config_map_aws_auth
        id:                                                 <computed>
        content:                                            "${data.template_file.config_map_aws_auth.rendered}"
        filename:                                           "./config-map-aws-auth_g1.yaml"

    + module.eks.local_file.kubeconfig
        id:                                                 <computed>
        content:                                            "${data.template_file.kubeconfig.rendered}"
        filename:                                           "./kubeconfig_g1"

    + module.eks.null_resource.tags_as_list_of_maps[0]
        id:                                                 <computed>
        triggers.%:                                         "3"
        triggers.key:                                       "GithubOrg"
        triggers.propagate_at_launch:                       "true"
        triggers.value:                                     "tikal"

    + module.eks.null_resource.tags_as_list_of_maps[1]
        id:                                                 <computed>
        triggers.%:                                         "3"
        triggers.key:                                       "GithubRepo"
        triggers.propagate_at_launch:                       "true"
        triggers.value:                                     "fuse-g1"

    + module.eks.null_resource.tags_as_list_of_maps[2]
        id:                                                 <computed>
        triggers.%:                                         "3"
        triggers.key:                                       "Workspace"
        triggers.propagate_at_launch:                       "true"
        triggers.value:                                     "g1"

    + module.eks.null_resource.update_config_map_aws_auth
        id:                                                 <computed>
        triggers.%:                                         <computed>

    + module.iam_user.aws_iam_access_key.this
        id:                                                 <computed>
        encrypted_secret:                                   <computed>
        key_fingerprint:                                    <computed>
        pgp_key:                                            "keybase:hagzag"
        secret:                                             <computed>
        ses_smtp_password:                                  <computed>
        status:                                             <computed>
        user:                                               "g1"

    + module.iam_user.aws_iam_user.this
        id:                                                 <computed>
        arn:                                                <computed>
        force_destroy:                                      "false"
        name:                                               "g1"
        path:                                               "/"
        unique_id:                                          <computed>

    + module.iam_user.aws_iam_user_login_profile.this
        id:                                                 <computed>
        encrypted_password:                                 <computed>
        key_fingerprint:                                    <computed>
        password_length:                                    "20"
        password_reset_required:                            "true"
        pgp_key:                                            "keybase:hagzag"
        user:                                               "g1"

    + module.iam_user.aws_iam_user_ssh_key.this
        id:                                                 <computed>
        encoding:                                           "SSH"
        fingerprint:                                        <computed>
        public_key:                                         "${var.ssh_public_key}"
        ssh_public_key_id:                                  <computed>
        status:                                             <computed>
        username:                                           "g1"

    + module.ssh_key_pair.aws_key_pair.generated
        id:                                                 <computed>
        fingerprint:                                        <computed>
        key_name:                                           "fuse-dev-g1"
        public_key:                                         "${tls_private_key.default.public_key_openssh}"

    + module.ssh_key_pair.local_file.private_key_pem
        id:                                                 <computed>
        content:                                            "${tls_private_key.default.private_key_pem}"
        filename:                                           "./secrets/fuse-dev-g1.pem"

    + module.ssh_key_pair.local_file.public_key_openssh
        id:                                                 <computed>
        content:                                            "${tls_private_key.default.public_key_openssh}"
        filename:                                           "./secrets/fuse-dev-g1.pub"

    + module.ssh_key_pair.null_resource.chmod
        id:                                                 <computed>
        triggers.%:                                         "1"
        triggers.local_file_private_key_pem:                "local_file.private_key_pem"

    + module.ssh_key_pair.tls_private_key.default
        id:                                                 <computed>
        algorithm:                                          "RSA"
        ecdsa_curve:                                        "P224"
        private_key_pem:                                    <computed>
        public_key_fingerprint_md5:                         <computed>
        public_key_openssh:                                 <computed>
        public_key_pem:                                     <computed>
        rsa_bits:                                           "2048"

    + module.subdomain.aws_route53_record.group-NS
        id:                                                 <computed>
        allow_overwrite:                                    "true"
        fqdn:                                               <computed>
        name:                                               "g1.fuse.tikal.io"
        records.#:                                          <computed>
        ttl:                                                "900"
        type:                                               "NS"
        zone_id:                                            "Z2IXOXV370WKTK"

    + module.subdomain.aws_route53_zone.main
        id:                                                 <computed>
        comment:                                            "Zone for g1.fuse.tikal.io"
        force_destroy:                                      "false"
        name:                                               "g1.fuse.tikal.io"
        name_servers.#:                                     <computed>
        vpc_id:                                             <computed>
        vpc_region:                                         <computed>
        zone_id:                                            <computed>

    + module.vpc.aws_internet_gateway.this
        id:                                                 <computed>
        owner_id:                                           <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_nat_gateway.this
        id:                                                 <computed>
        allocation_id:                                      "${element(local.nat_gateway_ips, (var.single_nat_gateway ? 0 : count.index))}"
        network_interface_id:                               <computed>
        private_ip:                                         <computed>
        public_ip:                                          <computed>
        subnet_id:                                          "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-eu-central-1a"
        tags.kubernetes.io/cluster/g1:                      "shared"

    + module.vpc.aws_route.private_nat_gateway
        id:                                                 <computed>
        destination_cidr_block:                             "0.0.0.0/0"
        destination_prefix_list_id:                         <computed>
        egress_only_gateway_id:                             <computed>
        gateway_id:                                         <computed>
        instance_id:                                        <computed>
        instance_owner_id:                                  <computed>
        nat_gateway_id:                                     "${element(aws_nat_gateway.this.*.id, count.index)}"
        network_interface_id:                               <computed>
        origin:                                             <computed>
        route_table_id:                                     "${element(aws_route_table.private.*.id, count.index)}"
        state:                                              <computed>

    + module.vpc.aws_route.public_internet_gateway
        id:                                                 <computed>
        destination_cidr_block:                             "0.0.0.0/0"
        destination_prefix_list_id:                         <computed>
        egress_only_gateway_id:                             <computed>
        gateway_id:                                         "${aws_internet_gateway.this.id}"
        instance_id:                                        <computed>
        instance_owner_id:                                  <computed>
        nat_gateway_id:                                     <computed>
        network_interface_id:                               <computed>
        origin:                                             <computed>
        route_table_id:                                     "${aws_route_table.public.id}"
        state:                                              <computed>

    + module.vpc.aws_route_table.private
        id:                                                 <computed>
        owner_id:                                           <computed>
        propagating_vgws.#:                                 <computed>
        route.#:                                            <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-private"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_route_table.public
        id:                                                 <computed>
        owner_id:                                           <computed>
        propagating_vgws.#:                                 <computed>
        route.#:                                            <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-public"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_route_table_association.private[0]
        id:                                                 <computed>
        route_table_id:                                     "${element(aws_route_table.private.*.id, (var.single_nat_gateway ? 0 : count.index))}"
        subnet_id:                                          "${element(aws_subnet.private.*.id, count.index)}"

    + module.vpc.aws_route_table_association.private[1]
        id:                                                 <computed>
        route_table_id:                                     "${element(aws_route_table.private.*.id, (var.single_nat_gateway ? 0 : count.index))}"
        subnet_id:                                          "${element(aws_subnet.private.*.id, count.index)}"

    + module.vpc.aws_route_table_association.private[2]
        id:                                                 <computed>
        route_table_id:                                     "${element(aws_route_table.private.*.id, (var.single_nat_gateway ? 0 : count.index))}"
        subnet_id:                                          "${element(aws_subnet.private.*.id, count.index)}"

    + module.vpc.aws_route_table_association.public[0]
        id:                                                 <computed>
        route_table_id:                                     "${aws_route_table.public.id}"
        subnet_id:                                          "${element(aws_subnet.public.*.id, count.index)}"

    + module.vpc.aws_route_table_association.public[1]
        id:                                                 <computed>
        route_table_id:                                     "${aws_route_table.public.id}"
        subnet_id:                                          "${element(aws_subnet.public.*.id, count.index)}"

    + module.vpc.aws_route_table_association.public[2]
        id:                                                 <computed>
        route_table_id:                                     "${aws_route_table.public.id}"
        subnet_id:                                          "${element(aws_subnet.public.*.id, count.index)}"

    + module.vpc.aws_subnet.private[0]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1a"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.48.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "false"
        owner_id:                                           <computed>
        tags.%:                                             "3"
        tags.Name:                                          "g1-vpc-private-eu-central-1a"
        tags.kubernetes.io/cluster/g1:                      "shared"
        tags.kubernetes.io/role/internal-elb:               "true"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_subnet.private[1]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1b"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.64.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "false"
        owner_id:                                           <computed>
        tags.%:                                             "3"
        tags.Name:                                          "g1-vpc-private-eu-central-1b"
        tags.kubernetes.io/cluster/g1:                      "shared"
        tags.kubernetes.io/role/internal-elb:               "true"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_subnet.private[2]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1c"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.80.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "false"
        owner_id:                                           <computed>
        tags.%:                                             "3"
        tags.Name:                                          "g1-vpc-private-eu-central-1c"
        tags.kubernetes.io/cluster/g1:                      "shared"
        tags.kubernetes.io/role/internal-elb:               "true"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_subnet.public[0]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1a"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.0.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "true"
        owner_id:                                           <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-public-eu-central-1a"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_subnet.public[1]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1b"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.16.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "true"
        owner_id:                                           <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-public-eu-central-1b"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_subnet.public[2]
        id:                                                 <computed>
        arn:                                                <computed>
        assign_ipv6_address_on_creation:                    "false"
        availability_zone:                                  "eu-central-1c"
        availability_zone_id:                               <computed>
        cidr_block:                                         "172.31.32.0/20"
        ipv6_cidr_block:                                    <computed>
        ipv6_cidr_block_association_id:                     <computed>
        map_public_ip_on_launch:                            "true"
        owner_id:                                           <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc-public-eu-central-1c"
        tags.kubernetes.io/cluster/g1:                      "shared"
        vpc_id:                                             "${local.vpc_id}"

    + module.vpc.aws_vpc.this
        id:                                                 <computed>
        arn:                                                <computed>
        assign_generated_ipv6_cidr_block:                   "false"
        cidr_block:                                         "172.31.0.0/16"
        default_network_acl_id:                             <computed>
        default_route_table_id:                             <computed>
        default_security_group_id:                          <computed>
        dhcp_options_id:                                    <computed>
        enable_classiclink:                                 <computed>
        enable_classiclink_dns_support:                     <computed>
        enable_dns_hostnames:                               "true"
        enable_dns_support:                                 "true"
        instance_tenancy:                                   "default"
        ipv6_association_id:                                <computed>
        ipv6_cidr_block:                                    <computed>
        main_route_table_id:                                <computed>
        owner_id:                                           <computed>
        tags.%:                                             "2"
        tags.Name:                                          "g1-vpc"
        tags.kubernetes.io/cluster/g1:                      "shared"

    + module.ssh_key_pair.module.label.null_resource.default
        id:                                                 <computed>
        triggers.%:                                         "5"
        triggers.attributes:                                ""
        triggers.id:                                        "fuse-dev-g1"
        triggers.name:                                      "g1"
        triggers.namespace:                                 "fuse"
        triggers.stage:                                     "dev"


    Plan: 63 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------

    This plan was saved to: tfplan

    To perform exactly these actions, run the following command to apply:
        terraform apply "tfplan"

    ```

* 1.4 Apply the plan "tfplan" created above <details><summary>`terrform apply tfplan`</summary>

    <p>

    ```sh
    terraform apply tfplan
        module.ssh_key_pair.tls_private_key.default: Creating...
        algorithm:                  "" => "RSA"
        ecdsa_curve:                "" => "P224"
        private_key_pem:            "" => "<computed>"
        public_key_fingerprint_md5: "" => "<computed>"
        public_key_openssh:         "" => "<computed>"
        public_key_pem:             "" => "<computed>"
        rsa_bits:                   "" => "2048"
        module.ssh_key_pair.module.label.null_resource.default: Creating...
        triggers.%:          "" => "5"
        triggers.attributes: "" => ""
        triggers.id:         "" => "fuse-dev-g1"
        triggers.name:       "" => "g1"
        triggers.namespace:  "" => "fuse"
        triggers.stage:      "" => "dev"
        module.eks.null_resource.tags_as_list_of_maps[1]: Creating...
        triggers.%:                   "" => "3"
        triggers.key:                 "" => "GithubRepo"
        triggers.propagate_at_launch: "" => "true"
        triggers.value:               "" => "fuse-g1"
        module.eks.null_resource.tags_as_list_of_maps[2]: Creating...
        triggers.%:                   "" => "3"
        triggers.key:                 "" => "Workspace"
        triggers.propagate_at_launch: "" => "true"
        triggers.value:               "" => "g1"
        module.eks.null_resource.tags_as_list_of_maps[0]: Creating...
        triggers.%:                   "" => "3"
        triggers.key:                 "" => "GithubOrg"
        triggers.propagate_at_launch: "" => "true"
        triggers.value:               "" => "tikal"
        module.eks.null_resource.tags_as_list_of_maps[2]: Creation complete after 0s (ID: 7439002109309551365)
        module.eks.null_resource.tags_as_list_of_maps[1]: Creation complete after 0s (ID: 2338341944793396205)
        module.eks.null_resource.tags_as_list_of_maps[0]: Creation complete after 0s (ID: 2134826204924141989)
        module.ssh_key_pair.module.label.null_resource.default: Creation complete after 0s (ID: 158547222325329556)
        module.ssh_key_pair.tls_private_key.default: Creation complete after 0s (ID: b3cb921f131e68d47fa889bfe75488e45923a407)
        module.ssh_key_pair.local_file.public_key_openssh: Creating...
        content:  "" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK4LlJU/BPTXsJOg2i803cPPfaJSR56nH524are+bQsqnKkvvA2azsgZ44SzlVSYMm4xFhcf26gkRilad29DCWv8Xc5GrDoSEEGpDQ2kjOxO/06u2gUgXF0la1qeHP16JPI1iqOkJfW/WY22oBbVUu3IUzBPAIFfs5MX7MU4oQG3CGk4+FBVTI6+YXl7E27FKrGWloMZmoeVR/cz8zO2XFBHhrsM4JlgIB2itR7Xrz7+FhfZHeEaY8b8ijsdl5aBA/tgbWWJK5Ce2TjdTjtg7AcLkHGOAG2S3KH1QE4mhtkGu/iclNeefZXqXpJP7LwdQi4Z5BBb1LJNdOjZm2gmuj\n"
        filename: "" => "./secrets/fuse-dev-g1.pub"
        module.ssh_key_pair.local_file.private_key_pem: Creating...
        content:  "" => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAyuC5SVPwT017CToNovNN3Dz32iUkeepx+duGq3vm0LKpypL7\nwNms7IGeOEs5VUmDJuMRYXH9uoJEYpWndvQwlr/F3ORqw6EhBBqQ0NpIzsTv9 <reducted> tktyh9UBOJobZBrv4nJ\nTXnn2V6l6ST+y8HUIuGeQQW9SyTXTo2ZtoJrowIDAQABAoIBAQDAWYBS/bqB9bwJ\na3kyXewcO9HiigSjcpzNgE2WmMqmZD6HSgRXPAqv0dTpGqkpK6GlZPQ9p44hHx <reducted> yUzPyR7GVbJXmYbECOOt3ADeSC9T+28jXhqickCp+KPnz/KujJA\nMVTNM9bsND/95MjpuE1FCiEd15a92wGLqIEh7ER/roAEDYCe+JqiK+q2LQJn4tmL\nI8yldYTkJYR/PPYD9Lya2uHMIJHEOUpllq0pMu5rAoGAE3jTfpj84puE+6qy9tO9\nLSsvK5oVxkGyT/qVM/6SuzpP3h+jbtCcH <reducted> 0SGClEt1Fq5nWD9p2h6u1Vzk\neJbmRWEgxTNCw51nCNN9wxuKIlfhPr+7h3spNEFFpfiOBGwCCpjHyPyqUbZCLFAz\n3i5d2QKBgQCGm9vCWBb2FsSkLCaHeLprwFj93IVOMC9AsSjuKwQFp9vJNoaQ7XwV\nNIVTeINvybP9YppoBuXnDq7R6UlrHr+M1rl9b+lbfM0LCkHkoafd+AZ14gAtwSON\nY506w8ufdcGqZLgqtTKEIZsIK3NtGb1AMyaGwepVYHWjVrr6vMDXug==\n-----END RSA PRIVATE KEY-----\n"
        filename: "" => "./secrets/fuse-dev-g1.pem"
        module.ssh_key_pair.local_file.public_key_openssh: Creation complete after 0s (ID: 588726b97b0261242f4fd9a86548015afc9ca035)
        module.ssh_key_pair.local_file.private_key_pem: Creation complete after 0s (ID: 6934e02d60cdd16d22d34411c12cfe8d8a38bf9a)
        module.ssh_key_pair.null_resource.chmod: Creating...
        triggers.%:                          "" => "1"
        triggers.local_file_private_key_pem: "" => "local_file.private_key_pem"
        module.ssh_key_pair.null_resource.chmod: Provisioning with 'local-exec'...
        module.ssh_key_pair.null_resource.chmod (local-exec): Executing: ["/bin/sh" "-c" "chmod 600 ./secrets/fuse-dev-g1.pem"]
        module.ssh_key_pair.null_resource.chmod: Creation complete after 0s (ID: 8935491143513309572)
        module.ssh_key_pair.aws_key_pair.generated: Creating...
        fingerprint: "" => "<computed>"
        key_name:    "" => "fuse-dev-g1"
        public_key:  "" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK4LlJU/BPTXsJOg2i803cPPfaJSR56nH524are+bQsqnKkvvA2azsgZ44SzlVSYMm4xFhcf26gkRilad29DCWv8Xc5GrDoSEEGpDQ2kjOxO/06u2gUgXF0la1qeHP16JPI1iqOkJfW/WY22oBbVUu3IUzBPAIFfs5MX7MU4oQG3CGk4+FBVTI6+YXl7E27FKrGWloMZmoeVR/cz8zO2XFBHhrsM4JlgIB2itR7Xrz7+FhfZHeEaY8b8ijsdl5aBA/tgbWWJK5Ce2TjdTjtg7AcLkHGOAG2S3KH1QE4mhtkGu/iclNeefZXqXpJP7LwdQi4Z5BBb1LJNdOjZm2gmuj"
        aws_eip.nat_gw: Creating...
        allocation_id:     "" => "<computed>"
        association_id:    "" => "<computed>"
        domain:            "" => "<computed>"
        instance:          "" => "<computed>"
        network_interface: "" => "<computed>"
        private_dns:       "" => "<computed>"
        private_ip:        "" => "<computed>"
        public_dns:        "" => "<computed>"
        public_ip:         "" => "<computed>"
        public_ipv4_pool:  "" => "<computed>"
        tags.%:            "" => "2"
        tags.Description:  "" => "A gw for private subnets egress internet aceess"
        tags.Name:         "" => "g1-vpc-nat_gw"
        vpc:               "" => "true"
        module.eks.aws_iam_role.cluster: Creating...
        arn:                   "" => "<computed>"
        assume_role_policy:    "" => "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"EKSClusterAssumeRole\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"eks.amazonaws.com\"\n      }\n    }\n  ]\n}"
        create_date:           "" => "<computed>"
        force_detach_policies: "" => "true"
        max_session_duration:  "" => "3600"
        name:                  "" => "<computed>"
        name_prefix:           "" => "g1"
        path:                  "" => "/"
        unique_id:             "" => "<computed>"
        module.iam_user.aws_iam_user.this: Creating...
        arn:           "" => "<computed>"
        force_destroy: "" => "false"
        name:          "" => "g1"
        path:          "" => "/"
        unique_id:     "" => "<computed>"
        module.vpc.aws_vpc.this: Creating...
        arn:                              "" => "<computed>"
        assign_generated_ipv6_cidr_block: "" => "false"
        cidr_block:                       "" => "172.31.0.0/16"
        default_network_acl_id:           "" => "<computed>"
        default_route_table_id:           "" => "<computed>"
        default_security_group_id:        "" => "<computed>"
        dhcp_options_id:                  "" => "<computed>"
        enable_classiclink:               "" => "<computed>"
        enable_classiclink_dns_support:   "" => "<computed>"
        enable_dns_hostnames:             "" => "true"
        enable_dns_support:               "" => "true"
        instance_tenancy:                 "" => "default"
        ipv6_association_id:              "" => "<computed>"
        ipv6_cidr_block:                  "" => "<computed>"
        main_route_table_id:              "" => "<computed>"
        owner_id:                         "" => "<computed>"
        tags.%:                           "" => "2"
        tags.Name:                        "" => "g1-vpc"
        tags.kubernetes.io/cluster/g1:    "" => "shared"
        module.ssh_key_pair.aws_key_pair.generated: Creation complete after 1s (ID: fuse-dev-g1)
        module.iam_user.aws_iam_user.this: Creation complete after 2s (ID: g1)
        module.iam_user.aws_iam_user_ssh_key.this: Creating...
        encoding:          "" => "SSH"
        fingerprint:       "" => "<computed>"
        public_key:        "" => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK4LlJU/BPTXsJOg2i803cPPfaJSR56nH524are+bQsqnKkvvA2azsgZ44SzlVSYMm4xFhcf26gkRilad29DCWv8Xc5GrDoSEEGpDQ2kjOxO/06u2gUgXF0la1qeHP16JPI1iqOkJfW/WY22oBbVUu3IUzBPAIFfs5MX7MU4oQG3CGk4+FBVTI6+YXl7E27FKrGWloMZmoeVR/cz8zO2XFBHhrsM4JlgIB2itR7Xrz7+FhfZHeEaY8b8ijsdl5aBA/tgbWWJK5Ce2TjdTjtg7AcLkHGOAG2S3KH1QE4mhtkGu/iclNeefZXqXpJP7LwdQi4Z5BBb1LJNdOjZm2gmuj\n"
        ssh_public_key_id: "" => "<computed>"
        status:            "" => "<computed>"
        username:          "" => "g1"
        module.iam_user.aws_iam_user_login_profile.this: Creating...
        encrypted_password:      "" => "<computed>"
        key_fingerprint:         "" => "<computed>"
        password_length:         "" => "20"
        password_reset_required: "" => "true"
        pgp_key:                 "" => "keybase:hagzag"
        user:                    "" => "g1"
        module.iam_user.aws_iam_access_key.this: Creating...
        encrypted_secret:  "" => "<computed>"
        key_fingerprint:   "" => "<computed>"
        pgp_key:           "" => "keybase:hagzag"
        secret:            "" => "<computed>"
        ses_smtp_password: "" => "<computed>"
        status:            "" => "<computed>"
        user:              "" => "g1"
        module.eks.data.template_file.map_users: Refreshing state...
        module.eks.aws_iam_role.cluster: Creation complete after 2s (ID: g120190709212211248700000001)
        module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy: Creating...
        policy_arn: "" => "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
        role:       "" => "g120190709212211248700000001"
        module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy: Creating...
        policy_arn: "" => "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        role:       "" => "g120190709212211248700000001"
        aws_eip.nat_gw: Creation complete after 2s (ID: eipalloc-0c2afab9da16b8737)
        module.subdomain.aws_route53_zone.main: Creating...
        comment:        "" => "Zone for g1.fuse.tikal.io"
        force_destroy:  "" => "false"
        name:           "" => "g1.fuse.tikal.io"
        name_servers.#: "" => "<computed>"
        vpc_id:         "" => "<computed>"
        vpc_region:     "" => "<computed>"
        zone_id:        "" => "<computed>"
        module.iam_user.aws_iam_user_ssh_key.this: Creation complete after 1s (ID: APKAUZHJQNF3RL63D2NU)
        module.iam_user.aws_iam_access_key.this: Creation complete after 1s (ID: AKIAUZHJQNF3QRVDT5RL)
        module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy: Creation complete after 1s (ID: g120190709212211248700000001-20190709212213262700000003)
        module.eks.aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy: Creation complete after 1s (ID: g120190709212211248700000001-20190709212213262300000002)
        module.iam_user.aws_iam_user_login_profile.this: Creation complete after 1s (ID: g1)
        module.vpc.aws_vpc.this: Creation complete after 5s (ID: vpc-088b145fc0df8a41a)
        module.vpc.aws_route_table.public: Creating...
        owner_id:                      "" => "<computed>"
        propagating_vgws.#:            "" => "<computed>"
        route.#:                       "" => "<computed>"
        tags.%:                        "" => "2"
        tags.Name:                     "" => "g1-vpc-public"
        tags.kubernetes.io/cluster/g1: "" => "shared"
        vpc_id:                        "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_internet_gateway.this: Creating...
        owner_id:                      "" => "<computed>"
        tags.%:                        "0" => "2"
        tags.Name:                     "" => "g1-vpc"
        tags.kubernetes.io/cluster/g1: "" => "shared"
        vpc_id:                        "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.public[2]: Creating...
        arn:                             "" => "<computed>"
        assign_ipv6_address_on_creation: "" => "false"
        availability_zone:               "" => "eu-central-1c"
        availability_zone_id:            "" => "<computed>"
        cidr_block:                      "" => "172.31.32.0/20"
        ipv6_cidr_block:                 "" => "<computed>"
        ipv6_cidr_block_association_id:  "" => "<computed>"
        map_public_ip_on_launch:         "" => "true"
        owner_id:                        "" => "<computed>"
        tags.%:                          "" => "2"
        tags.Name:                       "" => "g1-vpc-public-eu-central-1c"
        tags.kubernetes.io/cluster/g1:   "" => "shared"
        vpc_id:                          "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.public[0]: Creating...
        arn:                             "" => "<computed>"
        assign_ipv6_address_on_creation: "" => "false"
        availability_zone:               "" => "eu-central-1a"
        availability_zone_id:            "" => "<computed>"
        cidr_block:                      "" => "172.31.0.0/20"
        ipv6_cidr_block:                 "" => "<computed>"
        ipv6_cidr_block_association_id:  "" => "<computed>"
        map_public_ip_on_launch:         "" => "true"
        owner_id:                        "" => "<computed>"
        tags.%:                          "" => "2"
        tags.Name:                       "" => "g1-vpc-public-eu-central-1a"
        tags.kubernetes.io/cluster/g1:   "" => "shared"
        vpc_id:                          "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_route_table.private: Creating...
        owner_id:                      "" => "<computed>"
        propagating_vgws.#:            "" => "<computed>"
        route.#:                       "" => "<computed>"
        tags.%:                        "" => "2"
        tags.Name:                     "" => "g1-vpc-private"
        tags.kubernetes.io/cluster/g1: "" => "shared"
        vpc_id:                        "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.private[1]: Creating...
        arn:                                  "" => "<computed>"
        assign_ipv6_address_on_creation:      "" => "false"
        availability_zone:                    "" => "eu-central-1b"
        availability_zone_id:                 "" => "<computed>"
        cidr_block:                           "" => "172.31.64.0/20"
        ipv6_cidr_block:                      "" => "<computed>"
        ipv6_cidr_block_association_id:       "" => "<computed>"
        map_public_ip_on_launch:              "" => "false"
        owner_id:                             "" => "<computed>"
        tags.%:                               "" => "3"
        tags.Name:                            "" => "g1-vpc-private-eu-central-1b"
        tags.kubernetes.io/cluster/g1:        "" => "shared"
        tags.kubernetes.io/role/internal-elb: "" => "true"
        vpc_id:                               "" => "vpc-088b145fc0df8a41a"
        aws_security_group.eks-workers-controlPlaneSg: Creating...
        arn:                                   "" => "<computed>"
        description:                           "" => "Access to workers from within the vpc / via vpn"
        egress.#:                              "" => "<computed>"
        ingress.#:                             "" => "1"
        ingress.3024135210.cidr_blocks.#:      "" => "3"
        ingress.3024135210.cidr_blocks.0:      "" => "10.0.0.0/8"
        ingress.3024135210.cidr_blocks.1:      "" => "172.16.0.0/12"
        ingress.3024135210.cidr_blocks.2:      "" => "192.168.0.0/16"
        ingress.3024135210.description:        "" => ""
        ingress.3024135210.from_port:          "" => "22"
        ingress.3024135210.ipv6_cidr_blocks.#: "" => "0"
        ingress.3024135210.prefix_list_ids.#:  "" => "0"
        ingress.3024135210.protocol:           "" => "tcp"
        ingress.3024135210.security_groups.#:  "" => "0"
        ingress.3024135210.self:               "" => "false"
        ingress.3024135210.to_port:            "" => "22"
        name:                                  "" => "<computed>"
        name_prefix:                           "" => "all_worker_management"
        owner_id:                              "" => "<computed>"
        revoke_rules_on_delete:                "" => "false"
        vpc_id:                                "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.public[1]: Creating...
        arn:                             "" => "<computed>"
        assign_ipv6_address_on_creation: "" => "false"
        availability_zone:               "" => "eu-central-1b"
        availability_zone_id:            "" => "<computed>"
        cidr_block:                      "" => "172.31.16.0/20"
        ipv6_cidr_block:                 "" => "<computed>"
        ipv6_cidr_block_association_id:  "" => "<computed>"
        map_public_ip_on_launch:         "" => "true"
        owner_id:                        "" => "<computed>"
        tags.%:                          "" => "2"
        tags.Name:                       "" => "g1-vpc-public-eu-central-1b"
        tags.kubernetes.io/cluster/g1:   "" => "shared"
        vpc_id:                          "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.private[2]: Creating...
        arn:                                  "" => "<computed>"
        assign_ipv6_address_on_creation:      "" => "false"
        availability_zone:                    "" => "eu-central-1c"
        availability_zone_id:                 "" => "<computed>"
        cidr_block:                           "" => "172.31.80.0/20"
        ipv6_cidr_block:                      "" => "<computed>"
        ipv6_cidr_block_association_id:       "" => "<computed>"
        map_public_ip_on_launch:              "" => "false"
        owner_id:                             "" => "<computed>"
        tags.%:                               "" => "3"
        tags.Name:                            "" => "g1-vpc-private-eu-central-1c"
        tags.kubernetes.io/cluster/g1:        "" => "shared"
        tags.kubernetes.io/role/internal-elb: "" => "true"
        vpc_id:                               "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_route_table.public: Creation complete after 1s (ID: rtb-07232c2370cb683ae)
        module.eks.aws_security_group.cluster: Creating...
        arn:                    "" => "<computed>"
        description:            "" => "EKS cluster security group."
        egress.#:               "" => "<computed>"
        ingress.#:              "" => "<computed>"
        name:                   "" => "<computed>"
        name_prefix:            "" => "g1"
        owner_id:               "" => "<computed>"
        revoke_rules_on_delete: "" => "false"
        tags.%:                 "" => "4"
        tags.GithubOrg:         "" => "tikal"
        tags.GithubRepo:        "" => "fuse-g1"
        tags.Name:              "" => "g1-eks_cluster_sg"
        tags.Workspace:         "" => "g1"
        vpc_id:                 "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_route_table.private: Creation complete after 1s (ID: rtb-080426d1acaf8d26d)
        module.vpc.aws_subnet.private[0]: Creating...
        arn:                                  "" => "<computed>"
        assign_ipv6_address_on_creation:      "" => "false"
        availability_zone:                    "" => "eu-central-1a"
        availability_zone_id:                 "" => "<computed>"
        cidr_block:                           "" => "172.31.48.0/20"
        ipv6_cidr_block:                      "" => "<computed>"
        ipv6_cidr_block_association_id:       "" => "<computed>"
        map_public_ip_on_launch:              "" => "false"
        owner_id:                             "" => "<computed>"
        tags.%:                               "" => "3"
        tags.Name:                            "" => "g1-vpc-private-eu-central-1a"
        tags.kubernetes.io/cluster/g1:        "" => "shared"
        tags.kubernetes.io/role/internal-elb: "" => "true"
        vpc_id:                               "" => "vpc-088b145fc0df8a41a"
        module.vpc.aws_subnet.private[2]: Creation complete after 2s (ID: subnet-07ecd1ea75ddd1602)
        module.vpc.aws_subnet.private[1]: Creation complete after 2s (ID: subnet-01d165db7ae699253)
        module.vpc.aws_subnet.public[2]: Creation complete after 2s (ID: subnet-0be781f64f978550e)
        module.vpc.aws_subnet.public[1]: Creation complete after 2s (ID: subnet-05dbd3c3908634a60)
        module.vpc.aws_internet_gateway.this: Creation complete after 2s (ID: igw-0be650975c77f45dd)
        module.vpc.aws_subnet.public[0]: Creation complete after 2s (ID: subnet-06c492ec5955423b0)
        module.vpc.aws_route.public_internet_gateway: Creating...
        destination_cidr_block:     "" => "0.0.0.0/0"
        destination_prefix_list_id: "" => "<computed>"
        egress_only_gateway_id:     "" => "<computed>"
        gateway_id:                 "" => "igw-0be650975c77f45dd"
        instance_id:                "" => "<computed>"
        instance_owner_id:          "" => "<computed>"
        nat_gateway_id:             "" => "<computed>"
        network_interface_id:       "" => "<computed>"
        origin:                     "" => "<computed>"
        route_table_id:             "" => "rtb-07232c2370cb683ae"
        state:                      "" => "<computed>"
        module.vpc.aws_route_table_association.public[0]: Creating...
        route_table_id: "" => "rtb-07232c2370cb683ae"
        subnet_id:      "" => "subnet-06c492ec5955423b0"
        module.vpc.aws_route_table_association.public[2]: Creating...
        route_table_id: "" => "rtb-07232c2370cb683ae"
        subnet_id:      "" => "subnet-0be781f64f978550e"
        module.vpc.aws_route_table_association.public[1]: Creating...
        route_table_id: "" => "rtb-07232c2370cb683ae"
        subnet_id:      "" => "subnet-05dbd3c3908634a60"
        module.vpc.aws_nat_gateway.this: Creating...
        allocation_id:                 "" => "eipalloc-0c2afab9da16b8737"
        network_interface_id:          "" => "<computed>"
        private_ip:                    "" => "<computed>"
        public_ip:                     "" => "<computed>"
        subnet_id:                     "" => "subnet-06c492ec5955423b0"
        tags.%:                        "" => "2"
        tags.Name:                     "" => "g1-vpc-eu-central-1a"
        tags.kubernetes.io/cluster/g1: "" => "shared"
        module.vpc.aws_route_table_association.public[1]: Creation complete after 0s (ID: rtbassoc-0abf943497e4c03c3)
        module.vpc.aws_route_table_association.public[0]: Creation complete after 0s (ID: rtbassoc-006b6006513a72b2f)
        module.vpc.aws_route_table_association.public[2]: Creation complete after 0s (ID: rtbassoc-0158717fdb47e246f)
        aws_security_group.eks-workers-controlPlaneSg: Creation complete after 3s (ID: sg-0b933559fe88fa9c5)
        module.vpc.aws_route.public_internet_gateway: Creation complete after 1s (ID: r-rtb-07232c2370cb683ae1080289494)
        module.vpc.aws_subnet.private[0]: Creation complete after 2s (ID: subnet-07fdfd1daf6b3857d)
        module.vpc.aws_route_table_association.private[1]: Creating...
        route_table_id: "" => "rtb-080426d1acaf8d26d"
        subnet_id:      "" => "subnet-01d165db7ae699253"
        module.vpc.aws_route_table_association.private[2]: Creating...
        route_table_id: "" => "rtb-080426d1acaf8d26d"
        subnet_id:      "" => "subnet-07ecd1ea75ddd1602"
        module.vpc.aws_route_table_association.private[0]: Creating...
        route_table_id: "" => "rtb-080426d1acaf8d26d"
        subnet_id:      "" => "subnet-07fdfd1daf6b3857d"
        module.vpc.aws_route_table_association.private[0]: Creation complete after 0s (ID: rtbassoc-0d9206f87228f4871)
        module.vpc.aws_route_table_association.private[1]: Creation complete after 0s (ID: rtbassoc-0e7c8677a21d0a1dd)
        module.vpc.aws_route_table_association.private[2]: Creation complete after 0s (ID: rtbassoc-0acd45d024a80bf09)
        module.eks.aws_security_group.cluster: Creation complete after 3s (ID: sg-0840dc7dd839d47ce)
        module.eks.aws_security_group_rule.cluster_egress_internet: Creating...
        cidr_blocks.#:            "" => "1"
        cidr_blocks.0:            "" => "0.0.0.0/0"
        description:              "" => "Allow cluster egress access to the Internet."
        from_port:                "" => "0"
        protocol:                 "" => "-1"
        security_group_id:        "" => "sg-0840dc7dd839d47ce"
        self:                     "" => "false"
        source_security_group_id: "" => "<computed>"
        to_port:                  "" => "0"
        type:                     "" => "egress"
        module.eks.aws_eks_cluster.this: Creating...
        arn:                                       "" => "<computed>"
        certificate_authority.#:                   "" => "<computed>"
        created_at:                                "" => "<computed>"
        endpoint:                                  "" => "<computed>"
        name:                                      "" => "g1"
        platform_version:                          "" => "<computed>"
        role_arn:                                  "" => "arn:aws:iam::<reducted>:role/g120190709212211248700000001"
        version:                                   "" => "1.12"
        vpc_config.#:                              "" => "1"
        vpc_config.0.endpoint_private_access:      "" => "false"
        vpc_config.0.endpoint_public_access:       "" => "true"
        vpc_config.0.security_group_ids.#:         "" => "1"
        vpc_config.0.security_group_ids.472992621: "" => "sg-0840dc7dd839d47ce"
        vpc_config.0.subnet_ids.#:                 "" => "3"
        vpc_config.0.subnet_ids.2926226336:        "" => "subnet-07ecd1ea75ddd1602"
        vpc_config.0.subnet_ids.3258862397:        "" => "subnet-01d165db7ae699253"
        vpc_config.0.subnet_ids.3418672652:        "" => "subnet-07fdfd1daf6b3857d"
        vpc_config.0.vpc_id:                       "" => "<computed>"
        module.eks.aws_security_group_rule.cluster_egress_internet: Creation complete after 1s (ID: sgrule-3576580317)
        module.subdomain.aws_route53_zone.main: Still creating... (10s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (10s elapsed)
        module.subdomain.aws_route53_zone.main: Still creating... (20s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (20s elapsed)
        module.subdomain.aws_route53_zone.main: Still creating... (30s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (30s elapsed)
        module.subdomain.aws_route53_zone.main: Creation complete after 36s (ID: Z2DTXX8L51L9BK)
        module.subdomain.aws_route53_record.group-NS: Creating...
        allow_overwrite:    "" => "true"
        fqdn:               "" => "<computed>"
        name:               "" => "g1.fuse.tikal.io"
        records.#:          "" => "4"
        records.1501778250: "" => "ns-487.awsdns-60.com"
        records.153603945:  "" => "ns-920.awsdns-51.net"
        records.2411282629: "" => "ns-1830.awsdns-36.co.uk"
        records.975477338:  "" => "ns-1484.awsdns-57.org"
        ttl:                "" => "900"
        type:               "" => "NS"
        zone_id:            "" => "Z2IXOXV370WKTK"
        module.eks.aws_eks_cluster.this: Still creating... (30s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (40s elapsed)
        module.subdomain.aws_route53_record.group-NS: Still creating... (10s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (50s elapsed)
        module.subdomain.aws_route53_record.group-NS: Still creating... (20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (50s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m0s elapsed)
        module.subdomain.aws_route53_record.group-NS: Still creating... (30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (1m0s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m10s elapsed)
        module.subdomain.aws_route53_record.group-NS: Creation complete after 40s (ID: Z2IXOXV370WKTK_g1.fuse.tikal.io_NS)
        module.eks.aws_eks_cluster.this: Still creating... (1m10s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (1m20s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (1m30s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (1m40s elapsed)
        module.vpc.aws_nat_gateway.this: Still creating... (1m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (1m50s elapsed)
        module.vpc.aws_nat_gateway.this: Creation complete after 1m55s (ID: nat-0e7138451614fbbbc)
        module.vpc.aws_route.private_nat_gateway: Creating...
        destination_cidr_block:     "" => "0.0.0.0/0"
        destination_prefix_list_id: "" => "<computed>"
        egress_only_gateway_id:     "" => "<computed>"
        gateway_id:                 "" => "<computed>"
        instance_id:                "" => "<computed>"
        instance_owner_id:          "" => "<computed>"
        nat_gateway_id:             "" => "nat-0e7138451614fbbbc"
        network_interface_id:       "" => "<computed>"
        origin:                     "" => "<computed>"
        route_table_id:             "" => "rtb-080426d1acaf8d26d"
        state:                      "" => "<computed>"
        module.vpc.aws_route.private_nat_gateway: Creation complete after 0s (ID: r-rtb-080426d1acaf8d26d1080289494)
        module.eks.aws_eks_cluster.this: Still creating... (2m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (2m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (2m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (2m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (2m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (2m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (3m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (4m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (5m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (6m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (7m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m40s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (8m50s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (9m0s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (9m10s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (9m20s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (9m30s elapsed)
        module.eks.aws_eks_cluster.this: Still creating... (9m40s elapsed)
        module.eks.aws_eks_cluster.this: Creation complete after 9m46s (ID: g1)
        module.eks.aws_security_group.workers: Creating...
        arn:                           "" => "<computed>"
        description:                   "" => "Security group for all nodes in the cluster."
        egress.#:                      "" => "<computed>"
        ingress.#:                     "" => "<computed>"
        name:                          "" => "<computed>"
        name_prefix:                   "" => "g1"
        owner_id:                      "" => "<computed>"
        revoke_rules_on_delete:        "" => "false"
        tags.%:                        "" => "5"
        tags.GithubOrg:                "" => "tikal"
        tags.GithubRepo:               "" => "fuse-g1"
        tags.Name:                     "" => "g1-eks_worker_sg"
        tags.Workspace:                "" => "g1"
        tags.kubernetes.io/cluster/g1: "" => "owned"
        vpc_id:                        "" => "vpc-088b145fc0df8a41a"
        module.eks.aws_iam_role.workers: Creating...
        arn:                   "" => "<computed>"
        assume_role_policy:    "" => "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"EKSWorkerAssumeRole\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      }\n    }\n  ]\n}"
        create_date:           "" => "<computed>"
        force_detach_policies: "" => "true"
        max_session_duration:  "" => "3600"
        name:                  "" => "<computed>"
        name_prefix:           "" => "g1"
        path:                  "" => "/"
        unique_id:             "" => "<computed>"
        module.eks.data.template_file.kubeconfig: Refreshing state...
        module.eks.data.aws_iam_policy_document.worker_autoscaling: Refreshing state...
        module.eks.local_file.kubeconfig: Creating...
        content:  "" => "apiVersion: v1\npreferences: {}\nkind: Config\n\nclusters:\n- cluster:\n    server: https://83B2A2D8B4F3B9F188754337C9674A96.yl4.eu-central-1.eks.amazonaws.com\n    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EY3dPVEl4TWpnMU4xb1hEVEk1TURjd05qSXhNamcxTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT2pBCmxxei9EbCt3RG1XWGZBL0txTXd2Zk4zM3Z4U2xXU2FoT0NLUnJoSFVRNk5qWkVlMWVaR2xSWXRsKzZoUHFyQlMKL012VXcrYkRQSWNBYlZaNmZFYW9nSUMvbjF2NFdqTUE5NzdBZGl3bk45dlRTUHpOVWpCZjExT2phSXhzdklucwo0cnV4U3pUbExjV3dxRkh2eUZXd3ZMSkN5cWtiT2QvN0xOdUF0b2tBL3B3SngxU2w1WFVSZ05kTzQvbDY5SmUyCnE1Y2IrSHNkZDdacTRUbUdrVHdocGVMQW0rMFA1SjVibFA1T1dxUHdZdUdVUW8ydXNTWTVsWkQ5SzNib0VzYS8KcUoybHZoRGprYXlVV0pqSWhtdFRKbDZPalNGWmk5M1ZCdGdGTllaUnVwaWVDOTE2MjdqRXJVM1h1ZXdXek5tcApFMXdOVEE5NG1nYkExcXZ5bXZNQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFCNTJUQ3drc0s3Y2ZVamdIaXBmMWNQQWJCN2EKamtGQ0ZXcVR4MWdZRkRTTnNQZWlDMUhXd1dQeEp4dDd5WVlWeU5PekVPeWxIanAvdXZMbkNsb2dNc2JoR1VKTwpUT2lJTWJBR3laRmMrUXpGMFVBSFhjN2dpUENLK2xJdk5GMnk0YUhhbTVrQlZ5aDUwS0VuUUVZZUxScWJGbWtQCjQxTUVyTnplMkJEVlNkUGRkOVpPeU1BWWc3OUxTSkxaRDZwcWJBckQrQ091VzhSSEI4Z3RvQWgrdElVVG5rRGEKeDNYTUdEVW1BRnoyMndPMk9TZFc1dGNYbzFhSjVPTXZkK2Jad2lmcE5JOHRHMzk4cFMzUVEwZk5lUnZKMDZ4awp4UUM0TVBCSFNEMUFiNVFSZWRyK3VpR092bHRDbC85UG1yLzdncXJ3Y2VvbGFwL3NpTTlsSHFnWVk0WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=\n  name: eks_g1\n\ncontexts:\n- context:\n    cluster: eks_g1\n    user: eks_g1\n  name: eks_g1\n\ncurrent-context: eks_g1\n\nusers:\n- name: eks_g1\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      command: aws-iam-authenticator\n      args:\n        - \"token\"\n        - \"-i\"\n        - \"g1\"\n\n\n"
        filename: "" => "./kubeconfig_g1"
        module.eks.aws_iam_policy.worker_autoscaling: Creating...
        arn:         "" => "<computed>"
        description: "" => "EKS worker node autoscaling policy for cluster g1"
        name:        "" => "<computed>"
        name_prefix: "" => "eks-worker-autoscaling-g1"
        path:        "" => "/"
        policy:      "" => "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"eksWorkerAutoscalingAll\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ec2:DescribeLaunchTemplateVersions\",\n        \"autoscaling:DescribeTags\",\n        \"autoscaling:DescribeLaunchConfigurations\",\n        \"autoscaling:DescribeAutoScalingInstances\",\n        \"autoscaling:DescribeAutoScalingGroups\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Sid\": \"eksWorkerAutoscalingOwn\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"autoscaling:UpdateAutoScalingGroup\",\n        \"autoscaling:TerminateInstanceInAutoScalingGroup\",\n        \"autoscaling:SetDesiredCapacity\"\n      ],\n      \"Resource\": \"*\",\n      \"Condition\": {\n        \"StringEquals\": {\n          \"autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled\": \"true\",\n          \"autoscaling:ResourceTag/kubernetes.io/cluster/g1\": \"owned\"\n        }\n      }\n    }\n  ]\n}"
        module.eks.local_file.kubeconfig: Creation complete after 0s (ID: 0217c25cc1a11c10c0b86475565a121a59e9728c)
        module.eks.aws_iam_role.workers: Creation complete after 2s (ID: g120190709213206036100000008)
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly: Creating...
        policy_arn: "" => "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        role:       "" => "g120190709213206036100000008"
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy: Creating...
        policy_arn: "" => "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        role:       "" => "g120190709213206036100000008"
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy: Creating...
        policy_arn: "" => "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        role:       "" => "g120190709213206036100000008"
        module.eks.aws_iam_instance_profile.workers[0]: Creating...
        arn:         "" => "<computed>"
        create_date: "" => "<computed>"
        name:        "" => "<computed>"
        name_prefix: "" => "g1"
        path:        "" => "/"
        role:        "" => "g120190709213206036100000008"
        roles.#:     "" => "<computed>"
        unique_id:   "" => "<computed>"
        module.eks.data.template_file.userdata[1]: Refreshing state...
        module.eks.aws_iam_instance_profile.workers[1]: Creating...
        arn:         "" => "<computed>"
        create_date: "" => "<computed>"
        name:        "" => "<computed>"
        name_prefix: "" => "g1"
        path:        "" => "/"
        role:        "" => "g120190709213206036100000008"
        roles.#:     "" => "<computed>"
        unique_id:   "" => "<computed>"
        module.eks.data.template_file.userdata[0]: Refreshing state...
        module.eks.aws_iam_policy.worker_autoscaling: Creation complete after 2s (ID: arn:aws:iam::<reducted>:policy/eks-wo...toscaling-g120190709213206043900000009)
        module.eks.aws_iam_role_policy_attachment.workers_autoscaling: Creating...
        policy_arn: "" => "arn:aws:iam::<reducted>:policy/eks-worker-autoscaling-g120190709213206043900000009"
        role:       "" => "g120190709213206036100000008"
        module.eks.aws_security_group.workers: Creation complete after 3s (ID: sg-01725ae23ad2a5736)
        module.eks.aws_security_group_rule.workers_egress_internet: Creating...
        cidr_blocks.#:            "" => "1"
        cidr_blocks.0:            "" => "0.0.0.0/0"
        description:              "" => "Allow nodes all egress to the Internet."
        from_port:                "" => "0"
        protocol:                 "" => "-1"
        security_group_id:        "" => "sg-01725ae23ad2a5736"
        self:                     "" => "false"
        source_security_group_id: "" => "<computed>"
        to_port:                  "" => "0"
        type:                     "" => "egress"
        module.eks.aws_security_group_rule.workers_ingress_self: Creating...
        description:              "" => "Allow node to communicate with each other."
        from_port:                "" => "0"
        protocol:                 "" => "-1"
        security_group_id:        "" => "sg-01725ae23ad2a5736"
        self:                     "" => "false"
        source_security_group_id: "" => "sg-01725ae23ad2a5736"
        to_port:                  "" => "65535"
        type:                     "" => "ingress"
        module.eks.aws_security_group_rule.workers_ingress_cluster_https: Creating...
        description:              "" => "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
        from_port:                "" => "443"
        protocol:                 "" => "tcp"
        security_group_id:        "" => "sg-01725ae23ad2a5736"
        self:                     "" => "false"
        source_security_group_id: "" => "sg-0840dc7dd839d47ce"
        to_port:                  "" => "443"
        type:                     "" => "ingress"
        module.eks.aws_security_group_rule.workers_ingress_cluster: Creating...
        description:              "" => "Allow workers pods to receive communication from the cluster control plane."
        from_port:                "" => "1025"
        protocol:                 "" => "tcp"
        security_group_id:        "" => "sg-01725ae23ad2a5736"
        self:                     "" => "false"
        source_security_group_id: "" => "sg-0840dc7dd839d47ce"
        to_port:                  "" => "65535"
        type:                     "" => "ingress"
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEKSWorkerNodePolicy: Creation complete after 1s (ID: g120190709213206036100000008-2019070921320852430000000c)
        module.eks.aws_security_group_rule.cluster_https_worker_ingress: Creating...
        description:              "" => "Allow pods to communicate with the EKS cluster API."
        from_port:                "" => "443"
        protocol:                 "" => "tcp"
        security_group_id:        "" => "sg-0840dc7dd839d47ce"
        self:                     "" => "false"
        source_security_group_id: "" => "sg-01725ae23ad2a5736"
        to_port:                  "" => "443"
        type:                     "" => "ingress"
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEKS_CNI_Policy: Creation complete after 1s (ID: g120190709213206036100000008-2019070921320856120000000d)
        module.eks.aws_iam_role_policy_attachment.workers_AmazonEC2ContainerRegistryReadOnly: Creation complete after 1s (ID: g120190709213206036100000008-2019070921320857610000000e)
        module.eks.aws_iam_role_policy_attachment.workers_autoscaling: Creation complete after 2s (ID: g120190709213206036100000008-2019070921320885340000000f)
        module.eks.aws_iam_instance_profile.workers[0]: Creation complete after 2s (ID: g12019070921320784440000000a)
        module.eks.aws_iam_instance_profile.workers[1]: Creation complete after 2s (ID: g12019070921320784510000000b)
        module.eks.data.template_file.worker_role_arns[1]: Refreshing state...
        module.eks.data.template_file.worker_role_arns[0]: Refreshing state...
        module.eks.aws_launch_configuration.workers[0]: Creating...
        associate_public_ip_address:               "" => "false"
        ebs_block_device.#:                        "" => "<computed>"
        ebs_optimized:                             "" => "true"
        enable_monitoring:                         "" => "true"
        iam_instance_profile:                      "" => "g12019070921320784440000000a"
        image_id:                                  "" => "ami-0ee5ca4231511cafc"
        instance_type:                             "" => "m4.large"
        key_name:                                  "" => "fuse-dev-g1"
        name:                                      "" => "<computed>"
        name_prefix:                               "" => "g1-k8s-blue-workers"
        root_block_device.#:                       "" => "1"
        root_block_device.0.delete_on_termination: "" => "true"
        root_block_device.0.iops:                  "" => "0"
        root_block_device.0.volume_size:           "" => "48"
        root_block_device.0.volume_type:           "" => "gp2"
        security_groups.#:                         "" => "2"
        security_groups.1002269536:                "" => "sg-01725ae23ad2a5736"
        security_groups.2475997679:                "" => "sg-0b933559fe88fa9c5"
        user_data_base64:                          "" => "IyEvYmluL2Jhc2ggLXhlCgojIEFsbG93IHVzZXIgc3VwcGxpZWQgcHJlIHVzZXJkYXRhIGNvZGUKCgojIEJvb3RzdHJhcCBhbmQgam9pbiB0aGUgY2x1c3RlcgovZXRjL2Vrcy9ib290c3RyYXAuc2ggLS1iNjQtY2x1c3Rlci1jYSAnTFMwdExTMUNSVWRKVGlCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2sxSlNVTjVSRU5EUVdKRFowRjNTVUpCWjBsQ1FVUkJUa0puYTNGb2EybEhPWGN3UWtGUmMwWkJSRUZXVFZKTmQwVlJXVVJXVVZGRVJYZHdjbVJYU213S1kyMDFiR1JIVm5wTlFqUllSRlJGTlUxRVkzZFBWRWw0VFdwbk1VNHhiMWhFVkVrMVRVUmpkMDVxU1hoTmFtY3hUakZ2ZDBaVVJWUk5Ra1ZIUVRGVlJRcEJlRTFMWVROV2FWcFlTblZhV0ZKc1kzcERRMEZUU1hkRVVWbEtTMjlhU1doMlkwNUJVVVZDUWxGQlJHZG5SVkJCUkVORFFWRnZRMmRuUlVKQlQycEJDbXh4ZWk5RWJDdDNSRzFYV0daQkwwdHhUWGQyWms0ek0zWjRVMnhYVTJGb1QwTkxVbkpvU0ZWUk5rNXFXa1ZsTVdWYVIyeFNXWFJzS3pab1VIRnlRbE1LTDAxMlZYY3JZa1JRU1dOQllsWmFObVpGWVc5blNVTXZiakYyTkZkcVRVRTVOemRCWkdsM2JrNDVkbFJUVUhwT1ZXcENaakV4VDJwaFNYaHpka2x1Y3dvMGNuVjRVM3BVYkV4alYzZHhSa2gyZVVaWGQzWk1Ta041Y1d0aVQyUXZOMHhPZFVGMGIydEJMM0IzU25neFUydzFXRlZTWjA1a1R6UXZiRFk1U21VeUNuRTFZMklyU0hOa1pEZGFjVFJVYlVkclZIZG9jR1ZNUVcwck1GQTFTalZpYkZBMVQxZHhVSGRaZFVkVlVXOHlkWE5UV1RWc1drUTVTek5pYjBWellTOEtjVW95Ykhab1JHcHJZWGxWVjBwcVNXaHRkRlJLYkRaUGFsTkdXbWs1TTFaQ2RHZEdUbGxhVW5Wd2FXVkRPVEUyTWpkcVJYSlZNMWgxWlhkWGVrNXRjQXBGTVhkT1ZFRTVORzFuWWtFeGNYWjViWFpOUTBGM1JVRkJZVTFxVFVORmQwUm5XVVJXVWpCUVFWRklMMEpCVVVSQlowdHJUVUU0UjBFeFZXUkZkMFZDQ2k5M1VVWk5RVTFDUVdZNGQwUlJXVXBMYjFwSmFIWmpUa0ZSUlV4Q1VVRkVaMmRGUWtGQ05USlVRM2RyYzBzM1kyWlZhbWRJYVhCbU1XTlFRV0pDTjJFS2FtdEdRMFpYY1ZSNE1XZFpSa1JUVG5OUVpXbERNVWhYZDFkUWVFcDRkRGQ1V1ZsV2VVNVBla1ZQZVd4SWFuQXZkWFpNYmtOc2IyZE5jMkpvUjFWS1R3cFVUMmxKVFdKQlIzbGFSbU1yVVhwR01GVkJTRmhqTjJkcFVFTkxLMnhKZGs1R01uazBZVWhoYlRWclFsWjVhRFV3UzBWdVVVVlpaVXhTY1dKR2JXdFFDalF4VFVWeVRucGxNa0pFVmxOa1VHUmtPVnBQZVUxQldXYzNPVXhUU2t4YVJEWndjV0pCY2tRclEwOTFWemhTU0VJNFozUnZRV2dyZEVsVlZHNXJSR0VLZUROWVRVZEVWVzFCUm5veU1uZFBNazlUWkZjMWRHTlliekZoU2pWUFRYWmtLMkphZDJsbWNFNUpPSFJITXprNGNGTXpVVkV3Wms1bFVuWktNRFo0YXdwNFVVTTBUVkJDU0ZORU1VRmlOVkZTWldSeUszVnBSMDkyYkhSRGJDODVVRzF5THpkbmNYSjNZMlZ2YkdGd0wzTnBUVGxzU0hGbldWazBXVDBLTFMwdExTMUZUa1FnUTBWU1ZFbEdTVU5CVkVVdExTMHRMUW89JyAtLWFwaXNlcnZlci1lbmRwb2ludCAnaHR0cHM6Ly84M0IyQTJEOEI0RjNCOUYxODg3NTQzMzdDOTY3NEE5Ni55bDQuZXUtY2VudHJhbC0xLmVrcy5hbWF6b25hd3MuY29tJyAgLS1rdWJlbGV0LWV4dHJhLWFyZ3MgJy0tbm9kZS1sYWJlbHM9ZWtzX3dvcmtlcl9ncm91cD1ibHVlJyAnZzEnCgojIEFsbG93IHVzZXIgc3VwcGxpZWQgdXNlcmRhdGEgY29kZQoK"
        module.eks.aws_launch_configuration.workers[1]: Creating...
        associate_public_ip_address:               "" => "false"
        ebs_block_device.#:                        "" => "<computed>"
        ebs_optimized:                             "" => "true"
        enable_monitoring:                         "" => "true"
        iam_instance_profile:                      "" => "g12019070921320784510000000b"
        image_id:                                  "" => "ami-0ee5ca4231511cafc"
        instance_type:                             "" => "m4.large"
        key_name:                                  "" => "fuse-dev-g1"
        name:                                      "" => "<computed>"
        name_prefix:                               "" => "g1-k8s-green-workers"
        root_block_device.#:                       "" => "1"
        root_block_device.0.delete_on_termination: "" => "true"
        root_block_device.0.iops:                  "" => "0"
        root_block_device.0.volume_size:           "" => "48"
        root_block_device.0.volume_type:           "" => "gp2"
        security_groups.#:                         "" => "2"
        security_groups.1002269536:                "" => "sg-01725ae23ad2a5736"
        security_groups.2475997679:                "" => "sg-0b933559fe88fa9c5"
        user_data_base64:                          "" => "IyEvYmluL2Jhc2ggLXhlCgojIEFsbG93IHVzZXIgc3VwcGxpZWQgcHJlIHVzZXJkYXRhIGNvZGUKCgojIEJvb3RzdHJhcCBhbmQgam9pbiB0aGUgY2x1c3RlcgovZXRjL2Vrcy9ib290c3RyYXAuc2ggLS1iNjQtY2x1c3Rlci1jYSAnTFMwdExTMUNSVWRKVGlCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2sxSlNVTjVSRU5EUVdKRFowRjNTVUpCWjBsQ1FVUkJUa0puYTNGb2EybEhPWGN3UWtGUmMwWkJSRUZXVFZKTmQwVlJXVVJXVVZGRVJYZHdjbVJYU213S1kyMDFiR1JIVm5wTlFqUllSRlJGTlUxRVkzZFBWRWw0VFdwbk1VNHhiMWhFVkVrMVRVUmpkMDVxU1hoTmFtY3hUakZ2ZDBaVVJWUk5Ra1ZIUVRGVlJRcEJlRTFMWVROV2FWcFlTblZhV0ZKc1kzcERRMEZUU1hkRVVWbEtTMjlhU1doMlkwNUJVVVZDUWxGQlJHZG5SVkJCUkVORFFWRnZRMmRuUlVKQlQycEJDbXh4ZWk5RWJDdDNSRzFYV0daQkwwdHhUWGQyWms0ek0zWjRVMnhYVTJGb1QwTkxVbkpvU0ZWUk5rNXFXa1ZsTVdWYVIyeFNXWFJzS3pab1VIRnlRbE1LTDAxMlZYY3JZa1JRU1dOQllsWmFObVpGWVc5blNVTXZiakYyTkZkcVRVRTVOemRCWkdsM2JrNDVkbFJUVUhwT1ZXcENaakV4VDJwaFNYaHpka2x1Y3dvMGNuVjRVM3BVYkV4alYzZHhSa2gyZVVaWGQzWk1Ta041Y1d0aVQyUXZOMHhPZFVGMGIydEJMM0IzU25neFUydzFXRlZTWjA1a1R6UXZiRFk1U21VeUNuRTFZMklyU0hOa1pEZGFjVFJVYlVkclZIZG9jR1ZNUVcwck1GQTFTalZpYkZBMVQxZHhVSGRaZFVkVlVXOHlkWE5UV1RWc1drUTVTek5pYjBWellTOEtjVW95Ykhab1JHcHJZWGxWVjBwcVNXaHRkRlJLYkRaUGFsTkdXbWs1TTFaQ2RHZEdUbGxhVW5Wd2FXVkRPVEUyTWpkcVJYSlZNMWgxWlhkWGVrNXRjQXBGTVhkT1ZFRTVORzFuWWtFeGNYWjViWFpOUTBGM1JVRkJZVTFxVFVORmQwUm5XVVJXVWpCUVFWRklMMEpCVVVSQlowdHJUVUU0UjBFeFZXUkZkMFZDQ2k5M1VVWk5RVTFDUVdZNGQwUlJXVXBMYjFwSmFIWmpUa0ZSUlV4Q1VVRkVaMmRGUWtGQ05USlVRM2RyYzBzM1kyWlZhbWRJYVhCbU1XTlFRV0pDTjJFS2FtdEdRMFpYY1ZSNE1XZFpSa1JUVG5OUVpXbERNVWhYZDFkUWVFcDRkRGQ1V1ZsV2VVNVBla1ZQZVd4SWFuQXZkWFpNYmtOc2IyZE5jMkpvUjFWS1R3cFVUMmxKVFdKQlIzbGFSbU1yVVhwR01GVkJTRmhqTjJkcFVFTkxLMnhKZGs1R01uazBZVWhoYlRWclFsWjVhRFV3UzBWdVVVVlpaVXhTY1dKR2JXdFFDalF4VFVWeVRucGxNa0pFVmxOa1VHUmtPVnBQZVUxQldXYzNPVXhUU2t4YVJEWndjV0pCY2tRclEwOTFWemhTU0VJNFozUnZRV2dyZEVsVlZHNXJSR0VLZUROWVRVZEVWVzFCUm5veU1uZFBNazlUWkZjMWRHTlliekZoU2pWUFRYWmtLMkphZDJsbWNFNUpPSFJITXprNGNGTXpVVkV3Wms1bFVuWktNRFo0YXdwNFVVTTBUVkJDU0ZORU1VRmlOVkZTWldSeUszVnBSMDkyYkhSRGJDODVVRzF5THpkbmNYSjNZMlZ2YkdGd0wzTnBUVGxzU0hGbldWazBXVDBLTFMwdExTMUZUa1FnUTBWU1ZFbEdTVU5CVkVVdExTMHRMUW89JyAtLWFwaXNlcnZlci1lbmRwb2ludCAnaHR0cHM6Ly84M0IyQTJEOEI0RjNCOUYxODg3NTQzMzdDOTY3NEE5Ni55bDQuZXUtY2VudHJhbC0xLmVrcy5hbWF6b25hd3MuY29tJyAgLS1rdWJlbGV0LWV4dHJhLWFyZ3MgJy0tbm9kZS1sYWJlbHM9ZWtzX3dvcmtlcl9ncm91cD1ncmVlbicgJ2cxJwoKIyBBbGxvdyB1c2VyIHN1cHBsaWVkIHVzZXJkYXRhIGNvZGUKCg=="
        module.eks.data.template_file.config_map_aws_auth: Refreshing state...
        module.eks.local_file.config_map_aws_auth: Creating...
        content:  "" => "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: aws-auth\n  namespace: kube-system\ndata:\n  mapRoles: |\n    - rolearn: arn:aws:iam::<reducted>:role/g120190709213206036100000008\n      username: system:node:{{EC2PrivateDNSName}}\n      groups:\n        - system:bootstrappers\n        - system:nodes\n\n    - rolearn: arn:aws:iam::<reducted>:group/Admins\n      username: AGPAJZDNWWKOAYU6YPR4I\n      groups:\n        - system:masters\n\n  mapUsers: |\n    - userarn: arn:aws:iam::<reducted>:user/g1\n      username: g1\n      groups:\n        - system:masters\n\n  mapAccounts: |\n\n"
        filename: "" => "./config-map-aws-auth_g1.yaml"
        module.eks.null_resource.update_config_map_aws_auth: Creating...
        triggers.%:                        "" => "3"
        triggers.config_map_rendered:      "" => "apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: aws-auth\n  namespace: kube-system\ndata:\n  mapRoles: |\n    - rolearn: arn:aws:iam::<reducted>:role/g120190709213206036100000008\n      username: system:node:{{EC2PrivateDNSName}}\n      groups:\n        - system:bootstrappers\n        - system:nodes\n\n    - rolearn: arn:aws:iam::<reducted>:group/Admins\n      username: AGPAJZDNWWKOAYU6YPR4I\n      groups:\n        - system:masters\n\n  mapUsers: |\n    - userarn: arn:aws:iam::<reducted>:user/g1\n      username: g1\n      groups:\n        - system:masters\n\n  mapAccounts: |\n\n"
        triggers.endpoint:                 "" => "https://83B2A2D8B4F3B9F188754337C9674A96.yl4.eu-central-1.eks.amazonaws.com"
        triggers.kube_config_map_rendered: "" => "apiVersion: v1\npreferences: {}\nkind: Config\n\nclusters:\n- cluster:\n    server: https://83B2A2D8B4F3B9F188754337C9674A96.yl4.eu-central-1.eks.amazonaws.com\n    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EY3dPVEl4TWpnMU4xb1hEVEk1TURjd05qSXhNamcxTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT2pBCmxxei9EbCt3RG1XWGZBL0txTXd2Zk4zM3Z4U2xXU2FoT0NLUnJoSFVRNk5qWkVlMWVaR2xSWXRsKzZoUHFyQlMKL012VXcrYkRQSWNBYlZaNmZFYW9nSUMvbjF2NFdqTUE5NzdBZGl3bk45dlRTUHpOVWpCZjExT2phSXhzdklucwo0cnV4U3pUbExjV3dxRkh2eUZXd3ZMSkN5cWtiT2QvN0xOdUF0b2tBL3B3SngxU2w1WFVSZ05kTzQvbDY5SmUyCnE1Y2IrSHNkZDdacTRUbUdrVHdocGVMQW0rMFA1SjVibFA1T1dxUHdZdUdVUW8ydXNTWTVsWkQ5SzNib0VzYS8KcUoybHZoRGprYXlVV0pqSWhtdFRKbDZPalNGWmk5M1ZCdGdGTllaUnVwaWVDOTE2MjdqRXJVM1h1ZXdXek5tcApFMXdOVEE5NG1nYkExcXZ5bXZNQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFCNTJUQ3drc0s3Y2ZVamdIaXBmMWNQQWJCN2EKamtGQ0ZXcVR4MWdZRkRTTnNQZWlDMUhXd1dQeEp4dDd5WVlWeU5PekVPeWxIanAvdXZMbkNsb2dNc2JoR1VKTwpUT2lJTWJBR3laRmMrUXpGMFVBSFhjN2dpUENLK2xJdk5GMnk0YUhhbTVrQlZ5aDUwS0VuUUVZZUxScWJGbWtQCjQxTUVyTnplMkJEVlNkUGRkOVpPeU1BWWc3OUxTSkxaRDZwcWJBckQrQ091VzhSSEI4Z3RvQWgrdElVVG5rRGEKeDNYTUdEVW1BRnoyMndPMk9TZFc1dGNYbzFhSjVPTXZkK2Jad2lmcE5JOHRHMzk4cFMzUVEwZk5lUnZKMDZ4awp4UUM0TVBCSFNEMUFiNVFSZWRyK3VpR092bHRDbC85UG1yLzdncXJ3Y2VvbGFwL3NpTTlsSHFnWVk0WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=\n  name: eks_g1\n\ncontexts:\n- context:\n    cluster: eks_g1\n    user: eks_g1\n  name: eks_g1\n\ncurrent-context: eks_g1\n\nusers:\n- name: eks_g1\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      command: aws-iam-authenticator\n      args:\n        - \"token\"\n        - \"-i\"\n        - \"g1\"\n\n\n"
        module.eks.local_file.config_map_aws_auth: Creation complete after 0s (ID: 5c3c38e2fcd0a7b2d338f627198781de519b6177)
        module.eks.null_resource.update_config_map_aws_auth: Provisioning with 'local-exec'...
        module.eks.null_resource.update_config_map_aws_auth (local-exec): Executing: ["/bin/sh" "-c" "for i in `seq 1 10`; do \\\necho \"apiVersion: v1\npreferences: {}\nkind: Config\n\nclusters:\n- cluster:\n    server: https://83B2A2D8B4F3B9F188754337C9674A96.yl4.eu-central-1.eks.amazonaws.com\n    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EY3dPVEl4TWpnMU4xb1hEVEk1TURjd05qSXhNamcxTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT2pBCmxxei9EbCt3RG1XWGZBL0txTXd2Zk4zM3Z4U2xXU2FoT0NLUnJoSFVRNk5qWkVlMWVaR2xSWXRsKzZoUHFyQlMKL012VXcrYkRQSWNBYlZaNmZFYW9nSUMvbjF2NFdqTUE5NzdBZGl3bk45dlRTUHpOVWpCZjExT2phSXhzdklucwo0cnV4U3pUbExjV3dxRkh2eUZXd3ZMSkN5cWtiT2QvN0xOdUF0b2tBL3B3SngxU2w1WFVSZ05kTzQvbDY5SmUyCnE1Y2IrSHNkZDdacTRUbUdrVHdocGVMQW0rMFA1SjVibFA1T1dxUHdZdUdVUW8ydXNTWTVsWkQ5SzNib0VzYS8KcUoybHZoRGprYXlVV0pqSWhtdFRKbDZPalNGWmk5M1ZCdGdGTllaUnVwaWVDOTE2MjdqRXJVM1h1ZXdXek5tcApFMXdOVEE5NG1nYkExcXZ5bXZNQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFCNTJUQ3drc0s3Y2ZVamdIaXBmMWNQQWJCN2EKamtGQ0ZXcVR4MWdZRkRTTnNQZWlDMUhXd1dQeEp4dDd5WVlWeU5PekVPeWxIanAvdXZMbkNsb2dNc2JoR1VKTwpUT2lJTWJBR3laRmMrUXpGMFVBSFhjN2dpUENLK2xJdk5GMnk0YUhhbTVrQlZ5aDUwS0VuUUVZZUxScWJGbWtQCjQxTUVyTnplMkJEVlNkUGRkOVpPeU1BWWc3OUxTSkxaRDZwcWJBckQrQ091VzhSSEI4Z3RvQWgrdElVVG5rRGEKeDNYTUdEVW1BRnoyMndPMk9TZFc1dGNYbzFhSjVPTXZkK2Jad2lmcE5JOHRHMzk4cFMzUVEwZk5lUnZKMDZ4awp4UUM0TVBCSFNEMUFiNVFSZWRyK3VpR092bHRDbC85UG1yLzdncXJ3Y2VvbGFwL3NpTTlsSHFnWVk0WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=\n  name: eks_g1\n\ncontexts:\n- context:\n    cluster: eks_g1\n    user: eks_g1\n  name: eks_g1\n\ncurrent-context: eks_g1\n\nusers:\n- name: eks_g1\n  user:\n    exec:\n      apiVersion: client.authentication.k8s.io/v1alpha1\n      command: aws-iam-authenticator\n      args:\n        - \"token\"\n        - \"-i\"\n        - \"g1\"\n\n\n\" > kube_config.yaml & \\\necho \"apiVersion: v1\nkind: ConfigMap\nmetadata:\n  name: aws-auth\n  namespace: kube-system\ndata:\n  mapRoles: |\n    - rolearn: arn:aws:iam::<reducted>:role/g120190709213206036100000008\n      username: system:node:{{EC2PrivateDNSName}}\n      groups:\n        - system:bootstrappers\n        - system:nodes\n\n    - rolearn: arn:aws:iam::<reducted>:group/Admins\n      username: AGPAJZDNWWKOAYU6YPR4I\n      groups:\n        - system:masters\n\n  mapUsers: |\n    - userarn: arn:aws:iam::<reducted>:user/g1\n      username: g1\n      groups:\n        - system:masters\n\n  mapAccounts: |\n\n\" > aws_auth_configmap.yaml & \\\nkubectl apply -f aws_auth_configmap.yaml --kubeconfig kube_config.yaml && break || \\\nsleep 10; \\\ndone; \\\nrm aws_auth_configmap.yaml kube_config.yaml;\n"]
        module.eks.aws_security_group_rule.workers_egress_internet: Creation complete after 1s (ID: sgrule-301603152)
        module.eks.aws_security_group_rule.cluster_https_worker_ingress: Creation complete after 1s (ID: sgrule-2060602940)
        module.eks.aws_security_group_rule.workers_ingress_self: Creation complete after 2s (ID: sgrule-1547459982)
        module.eks.aws_security_group_rule.workers_ingress_cluster_https: Creation complete after 3s (ID: sgrule-177360194)
        module.eks.aws_security_group_rule.workers_ingress_cluster: Creation complete after 5s (ID: sgrule-10024156)
        module.eks.null_resource.update_config_map_aws_auth (local-exec): configmap/aws-auth created
        module.eks.null_resource.update_config_map_aws_auth: Creation complete after 4s (ID: 3448904941094310987)
        module.eks.aws_launch_configuration.workers.0: Still creating... (10s elapsed)
        module.eks.aws_launch_configuration.workers.1: Still creating... (10s elapsed)
        module.eks.aws_launch_configuration.workers[0]: Creation complete after 11s (ID: g1-k8s-blue-workers20190709213210590400000011)
        module.eks.aws_launch_configuration.workers[1]: Creation complete after 11s (ID: g1-k8s-green-workers20190709213210586300000010)
        module.eks.aws_autoscaling_group.workers[0]: Creating...
        arn:                            "" => "<computed>"
        default_cooldown:               "" => "<computed>"
        desired_capacity:               "" => "3"
        force_delete:                   "" => "false"
        health_check_grace_period:      "" => "300"
        health_check_type:              "" => "<computed>"
        launch_configuration:           "" => "g1-k8s-blue-workers20190709213210590400000011"
        load_balancers.#:               "" => "<computed>"
        max_size:                       "" => "9"
        metrics_granularity:            "" => "1Minute"
        min_size:                       "" => "1"
        name:                           "" => "<computed>"
        name_prefix:                    "" => "g1-k8s-blue-workers"
        protect_from_scale_in:          "" => "true"
        service_linked_role_arn:        "" => "<computed>"
        suspended_processes.#:          "" => "1"
        suspended_processes.658532077:  "" => "AZRebalance"
        tags.#:                         "" => "8"
        tags.0.%:                       "" => "3"
        tags.0.key:                     "" => "Name"
        tags.0.propagate_at_launch:     "" => "1"
        tags.0.value:                   "" => "g1-k8s-blue-workers-eks_asg"
        tags.1.%:                       "" => "3"
        tags.1.key:                     "" => "kubernetes.io/cluster/g1"
        tags.1.propagate_at_launch:     "" => "1"
        tags.1.value:                   "" => "owned"
        tags.2.%:                       "" => "3"
        tags.2.key:                     "" => "k8s.io/cluster-autoscaler/enabled"
        tags.2.propagate_at_launch:     "" => "0"
        tags.2.value:                   "" => "true"
        tags.3.%:                       "" => "3"
        tags.3.key:                     "" => "k8s.io/cluster-autoscaler/g1"
        tags.3.propagate_at_launch:     "" => "0"
        tags.3.value:                   "" => ""
        tags.4.%:                       "" => "3"
        tags.4.key:                     "" => "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
        tags.4.propagate_at_launch:     "" => "0"
        tags.4.value:                   "" => "48Gi"
        tags.5.%:                       "" => "3"
        tags.5.key:                     "" => "GithubOrg"
        tags.5.propagate_at_launch:     "" => "1"
        tags.5.value:                   "" => "tikal"
        tags.6.%:                       "" => "3"
        tags.6.key:                     "" => "GithubRepo"
        tags.6.propagate_at_launch:     "" => "1"
        tags.6.value:                   "" => "fuse-g1"
        tags.7.%:                       "" => "3"
        tags.7.key:                     "" => "Workspace"
        tags.7.propagate_at_launch:     "" => "1"
        tags.7.value:                   "" => "g1"
        vpc_zone_identifier.#:          "" => "3"
        vpc_zone_identifier.2853695661: "" => "subnet-07fdfd1daf6b3857d"
        vpc_zone_identifier.3031145205: "" => "subnet-07ecd1ea75ddd1602"
        vpc_zone_identifier.3873368737: "" => "subnet-01d165db7ae699253"
        wait_for_capacity_timeout:      "" => "10m"
        module.eks.aws_autoscaling_group.workers[1]: Creating...
        arn:                            "" => "<computed>"
        default_cooldown:               "" => "<computed>"
        desired_capacity:               "" => "0"
        force_delete:                   "" => "false"
        health_check_grace_period:      "" => "300"
        health_check_type:              "" => "<computed>"
        launch_configuration:           "" => "g1-k8s-green-workers20190709213210586300000010"
        load_balancers.#:               "" => "<computed>"
        max_size:                       "" => "0"
        metrics_granularity:            "" => "1Minute"
        min_size:                       "" => "0"
        name:                           "" => "<computed>"
        name_prefix:                    "" => "g1-k8s-green-workers"
        protect_from_scale_in:          "" => "false"
        service_linked_role_arn:        "" => "<computed>"
        suspended_processes.#:          "" => "1"
        suspended_processes.658532077:  "" => "AZRebalance"
        tags.#:                         "" => "8"
        tags.0.%:                       "" => "3"
        tags.0.key:                     "" => "Name"
        tags.0.propagate_at_launch:     "" => "1"
        tags.0.value:                   "" => "g1-k8s-green-workers-eks_asg"
        tags.1.%:                       "" => "3"
        tags.1.key:                     "" => "kubernetes.io/cluster/g1"
        tags.1.propagate_at_launch:     "" => "1"
        tags.1.value:                   "" => "owned"
        tags.2.%:                       "" => "3"
        tags.2.key:                     "" => "k8s.io/cluster-autoscaler/disabled"
        tags.2.propagate_at_launch:     "" => "0"
        tags.2.value:                   "" => "true"
        tags.3.%:                       "" => "3"
        tags.3.key:                     "" => "k8s.io/cluster-autoscaler/g1"
        tags.3.propagate_at_launch:     "" => "0"
        tags.3.value:                   "" => ""
        tags.4.%:                       "" => "3"
        tags.4.key:                     "" => "k8s.io/cluster-autoscaler/node-template/resources/ephemeral-storage"
        tags.4.propagate_at_launch:     "" => "0"
        tags.4.value:                   "" => "48Gi"
        tags.5.%:                       "" => "3"
        tags.5.key:                     "" => "GithubOrg"
        tags.5.propagate_at_launch:     "" => "1"
        tags.5.value:                   "" => "tikal"
        tags.6.%:                       "" => "3"
        tags.6.key:                     "" => "GithubRepo"
        tags.6.propagate_at_launch:     "" => "1"
        tags.6.value:                   "" => "fuse-g1"
        tags.7.%:                       "" => "3"
        tags.7.key:                     "" => "Workspace"
        tags.7.propagate_at_launch:     "" => "1"
        tags.7.value:                   "" => "g1"
        vpc_zone_identifier.#:          "" => "3"
        vpc_zone_identifier.2853695661: "" => "subnet-07fdfd1daf6b3857d"
        vpc_zone_identifier.3031145205: "" => "subnet-07ecd1ea75ddd1602"
        vpc_zone_identifier.3873368737: "" => "subnet-01d165db7ae699253"
        wait_for_capacity_timeout:      "" => "10m"
        module.eks.aws_autoscaling_group.workers[1]: Creation complete after 2s (ID: g1-k8s-green-workers20190709213220974600000013)
        module.eks.aws_autoscaling_group.workers.0: Still creating... (10s elapsed)
        module.eks.aws_autoscaling_group.workers.0: Still creating... (20s elapsed)
        module.eks.aws_autoscaling_group.workers.0: Still creating... (30s elapsed)
        module.eks.aws_autoscaling_group.workers.0: Still creating... (40s elapsed)
        module.eks.aws_autoscaling_group.workers[0]: Creation complete after 45s (ID: g1-k8s-blue-workers20190709213220974000000012)

        Apply complete! Resources: 63 added, 0 changed, 0 destroyed.

        Outputs:

        cluster_ca_certificate = LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EY3dPVEl4TWpnMU4xb1hEVEk1TURjd05qSXhNamcxTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaW< r e d u c t e d > N2dpUENLK2xJdk5GMnk0YUhhbTVrQlZ5aDUwS0VuUUVZZUxScWJGbWtQCjQxTUVyTnplMkJEVlNkUGRkOVpPeU1BWWc3OUxTSkxaRDZwcWJBckQrQ091VzhSSEI4Z3RvQWgrdElVVG5rRGEKeDNYTUdEVW1BRnoyMndPMk9TZFc1dGNYbzFhSjVPTXZkK2Jad2lmcE5JOHRHMzk4cFMzUVEwZk5lUnZKMDZ4awp4UUM0TVBCSFNEMUFiNVFSZWRyK3VpR092bHRDbC85UG1yLzdncXJ3Y2VvbGFwL3NpTTlsSHFnWVk0WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
        cluster_endpoint = https://< r e d u c t e d >.yl4.eu-central-1.eks.amazonaws.com
        kubeconfig = apiVersion: v1
        preferences: {}
        kind: Config

        clusters:
        - cluster:
            server: https://83B2A2D8B4F3B9F188754337C9674A96.yl4.eu-central-1.eks.amazonaws.com
            certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNU1EY3dPVEl4TWpnMU4xb1hEVEk1TURjd05qSXhNamcxTjFvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBT2pBCmxxei9EbCt3RG1XWGZBL0txTXd2Zk4zM3Z4U2xXU2FoT0NLUnJoSFVRNk5qWkVlMWVaR2xSWXRsKzZoUHFyQlMKL012VXcrYkRQSWNBYlZaNmZFYW9nSUMvbjF2NFdqTUE5NzdBZGl3bk45dlRTUHpOVWpCZjExT2phSXhzdklucwo0cnV4U3pU< r e d u c t e d > 3SngxU2w1WFVSZ05kTzQvbDY5SmUyCnE1Y2IrSHNkZDdacTRUbUdrVHdocGVMQW0rMFA1SjVibFA1T1dxUHdZdUdVUW8ydXNTWTVsWkQ5SzNib0VzYS8KcUoybHZoRGprYXlVV0pqSWhtdFRKbDZPalNG< r e d u c t e d > PekVPeWxIanAvdXZMbkNsb2dNc2JoR1VKTwpUT2lJTWJBR3laRmMrUXpGMFVBSFhjN2dpUENLK2xJdk5GMnk0YUhhbTVrQlZ5aDUwS0VuUUVZZUxScWJGbWtQCjQxTUVyTnplMkJEVlNkUGRkOVpPeU1BWWc3OUxTSkxaRDZwcWJBckQrQ091VzhSSEI4Z3RvQWgrdElVVG5rRGEKeDNYTUdEVW1BRnoyMndPMk9TZFc1dGNYbzFhSjVPTXZkK2Jad2lmcE5JOHRHMzk4cFMzUVEwZk5lUnZKMDZ4awp4UUM0TVBCSFNEMUFiNVFSZWRyK3VpR092bHRDbC85UG1yLzdncXJ3Y2VvbGFwL3NpTTlsSHFnWVk0WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
        name: eks_g1

        contexts:
        - context:
            cluster: eks_g1
            user: eks_g1
        name: eks_g1

        current-context: eks_g1

        users:
        - name: eks_g1
        user:
            exec:
            apiVersion: client.authentication.k8s.io/v1alpha1
            command: aws-iam-authenticator
            args:
                - "token"
                - "-i"
                - "g1"
        hagzags-mac:k8s_infra hagzag$
        hagzags-mac:k8s_infra hagzag$ export KUBECFG="`pwd`/kubeconfig_`terraform workspace show`"
        hagzags-mac:k8s_infra hagzag$
        hagzags-mac:k8s_infra hagzag$ kubectl get nodes --show-labels
        error: the server doesn't have a resource type "nodes"
        hagzags-mac:k8s_infra hagzag$ cd -ll
        -bash: cd: -l: invalid option
        cd: usage: cd [-L|[-P [-e]] [-@]] [dir]
        hagzags-mac:k8s_infra hagzag$ ll
        total 448
        drwxr-xr-x 20 hagzag staff    640 Jul 10 00:32 ./
        drwxr-xr-x 11 hagzag staff    352 Jul  9 21:55 ../
        drwxr-xr-x  6 hagzag staff    192 Jul 10 00:19 .terraform/
        drwxr-xr-x  4 hagzag staff    128 Jul 10 00:22 secrets/
        -rw-r--r--  1 hagzag staff      8 Jul  8 17:55 .terraform-version
        -rw-r--r--  1 hagzag staff    168 Jul  9 23:12 backend_s3.tf
        -rwxr-xr-x  1 hagzag staff    569 Jul 10 00:32 config-map-aws-auth_g1.yaml*
        -rw-r--r--  1 hagzag staff    244 Jul  8 09:39 data.tf
        lrwxr-xr-x  1 hagzag staff     22 Jul  8 17:55 global_variables.tf -> ../global_variables.tf
        lrwxr-xr-x  1 hagzag staff     14 Jul  8 09:39 k8s_vars.tf -> ../k8s_vars.tf
        -rwxr-xr-x  1 hagzag staff   1865 Jul 10 00:32 kubeconfig_g1*
        -rw-r--r--  1 hagzag staff   5451 Jul  9 21:55 main.tf
        -rw-r--r--  1 hagzag staff    233 Jul  9 00:52 outputs.tf
        -rw-r--r--  1 hagzag staff    321 Jul  8 09:39 providers.tf
        -rw-r--r--  1 hagzag staff      0 Jul 10 00:19 terraform.tfstate
        -rw-r--r--  1 hagzag staff 194733 Jul 10 00:19 terraform.tfstate.backup
        -rw-r--r--  1 hagzag staff    282 Jul  9 15:15 terraform.tfstate_froms3
        lrwxr-xr-x  1 hagzag staff     19 Jul  8 09:39 terraform.tfvars -> ../terraform.tfvars
        -rw-r--r--  1 hagzag staff 213473 Jul 10 00:22 tfplan
        -rw-r--r--  1 hagzag staff      1 Jul  8 09:39 vpc.tf
        hagzags-mac:k8s_infra hagzag$ set_kubeconfig kubeconfig_g1
        hagzags-mac:k8s_infra hagzag$ k get nodes
        NAME                                             STATUS    ROLES     AGE       VERSION
        ip-172-31-54-132.eu-central-1.compute.internal   Ready     <none>    89s       v1.12.7
        ip-172-31-78-127.eu-central-1.compute.internal   Ready     <none>    89s       v1.12.7
        ip-172-31-87-105.eu-central-1.compute.internal   Ready     <none>    89s       v1.12.7
        hagzags-mac:k8s_infra hagzag$ k get nodes --sho
        --show-kind    --show-labels
        hagzags-mac:k8s_infra hagzag$ k get nodes --show-labels
        NAME                                             STATUS    ROLES     AGE       VERSION   LABELS
        ip-172-31-54-132.eu-central-1.compute.internal   Ready     <none>    95s       v1.12.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m4.large,beta.kubernetes.io/os=linux,eks_worker_group=blue,failure-domain.beta.kubernetes.io/region=eu-central-1,failure-domain.beta.kubernetes.io/zone=eu-central-1a,kubernetes.io/hostname=ip-172-31-54-132.eu-central-1.compute.internal
        ip-172-31-78-127.eu-central-1.compute.internal   Ready     <none>    95s       v1.12.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m4.large,beta.kubernetes.io/os=linux,eks_worker_group=blue,failure-domain.beta.kubernetes.io/region=eu-central-1,failure-domain.beta.kubernetes.io/zone=eu-central-1b,kubernetes.io/hostname=ip-172-31-78-127.eu-central-1.compute.internal
        ip-172-31-87-105.eu-central-1.compute.internal   Ready     <none>    95s       v1.12.7   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/instance-type=m4.large,beta.kubernetes.io/os=linux,eks_worker_group=blue,failure-domain.beta.kubernetes.io/region=eu-central-1,failure-domain.beta.kubernetes.io/zone=eu-central-1c,kubernetes.io/hostname=ip-172-31-87-105.eu-central-1.compute.internal
    ```

    </p>

* 1.4 set kubernetes config
  
  ```sh
  export KUBECONFIG="`pwd`/kubeconfig_`terraform workspace show`"
  ```

* 1.5 see we have nodes ...

  ```sh
  kubectl get nodes
	NAME                                             STATUS    ROLES     AGE       VERSION
	ip-172-31-54-132.eu-central-1.compute.internal   Ready     <none>    23m       v1.12.7
	ip-172-31-78-127.eu-central-1.compute.internal   Ready     <none>    23m       v1.12.7
	ip-172-31-87-105.eu-central-1.compute.internal   Ready     <none>    23m       v1.12.7
  ```

### 2. step 2 setup apps (k8s_apps):
