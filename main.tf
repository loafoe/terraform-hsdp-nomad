locals {
  cartel_token  = var.region == "us-east" ? var.us_cartel_token : var.eu_cartel_token
  cartel_secret = var.region == "us-east" ? var.us_cartel_secret : var.eu_cartel_secret
}

resource "random_pet" "deploy" {
}

module "nomad_nodes" {
  count = 1

  source = "./modules/node"

  server_ip  = hsdp_container_host.nomad_server.private_ip
  name       = "${random_pet.deploy.id}-node-${count.index}"
  datacenter = "dc2"
  region     = "global"

  instance_type = var.instance_type

  user        = var.ldap_user
  user_groups = [var.ldap_user]

  nomad_image = var.nomad_image
}
