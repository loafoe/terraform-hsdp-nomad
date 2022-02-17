locals {
  cartel_token     = var.region == "us-east" ? var.us_cartel_token : var.eu_cartel_token
  cartel_secret    = var.region == "us-east" ? var.us_cartel_secret : var.eu_cartel_secret
  hostname_postfix = "${random_pet.deploy.id}.${data.hsdp_config.cf.domain}"
  secret_id        = join("", regex("Secret\\s+ID\\s+=\\s+(.*[^\\n])", module.nomad_server.nomad_result))
  nomad_addr       = "https://${cloudfoundry_route.nomad.endpoint}:4443"
}

resource "random_pet" "deploy" {
}


moved {
  from = hsdp_container_host.nomad_server
  to   = module.nomad_server.hsdp_container_host.nomad_server
}

module "nomad_server" {
  source = "./modules/server"

  name           = "${random_pet.deploy.id}-server"
  datacenter     = "dc1"
  region         = "global"
  docker_runtime = var.docker_runtime

  instance_type = var.instance_type

  user        = var.ldap_user
  ldap_user   = var.ldap_user
  user_groups = [var.ldap_user]

  nomad_image  = var.nomad_image
  consul_image = var.consul_image

  hostname_postfix = local.hostname_postfix
}


module "nomad_nodes" {
  count = 1

  source = "./modules/node"

  server_ip      = module.nomad_server.private_ip
  name           = "${random_pet.deploy.id}-node-${count.index}"
  datacenter     = "dc2"
  region         = "global"
  docker_runtime = var.docker_runtime

  instance_type = var.instance_type

  user        = var.ldap_user
  user_groups = [var.ldap_user]

  nomad_image  = var.nomad_image
  consul_image = var.consul_image

  hostname_postfix = local.hostname_postfix
}
