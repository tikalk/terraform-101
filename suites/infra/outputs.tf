output "cluster_ca_certificate" {
  value = "${module.eks.cluster_certificate_authority_data}"
}

output "cluster_endpoint" {
  value = "${module.eks.cluster_endpoint}"
}

output "kubeconfig" {
  value = "${module.eks.kubeconfig}"
}

output "kubeconfig_filename" {
  value = "${module.eks.kubeconfig_filename}"
}

output "aws_access_secret_key" {
  description = "The unique ID assigned by AWS"
  value       = "${module.iam_user.keybase_secret_key_decrypt_command}"
}

output "aws_access_key_id" {
  description = "The encrypted password, base64 encoded"
  value       = "${module.iam_user.this_iam_access_key_id}"
}

/*
keys will be deployed only when resource doesn't exist.
In order to redeploy keys a resource must be marked for recreation by using 'terraform taint' command:
  terraform taint null_resource.deploy_public_key
  terraform taint null_resource.deploy_private_key

Apply resources again and keys will be redeploy
*/
resource "null_resource" "deploy_public_key" {
  count = "${var.distribute_via_keybase}"

  provisioner "local-exec" {
    command = "keybase fs cp -f ${module.ssh_key_pair.public_key_filename} /keybase/team/chaosfuse.${terraform.workspace}"
  }
}

resource "null_resource" "deploy_private_key" {
  count = "${var.distribute_via_keybase}"

  provisioner "local-exec" {
    command = "keybase fs cp -f ${module.ssh_key_pair.private_key_filename} /keybase/team/chaosfuse.${terraform.workspace}"
  }
}
