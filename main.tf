locals {
  cartel_token     = var.region == "us-east" ? var.us_cartel_token : var.eu_cartel_token
  cartel_secret    = var.region == "us-east" ? var.us_cartel_secret : var.eu_cartel_secret
  hostname_postfix = "${random_pet.deploy.id}.${data.hsdp_config.cf.domain}"
  secret_id        = join("", regex("Secret\\s+ID\\s+=\\s+(.*[^\\n])", hsdp_container_host_exec.nomad_server_init.result))
  nomad_addr       = "https://${cloudfoundry_route.nomad.endpoint}:4443"
}

resource "random_pet" "deploy" {
}

module "nomad_nodes" {
  count = 1

  source = "./modules/node"

  server_ip      = hsdp_container_host.nomad_server.private_ip
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
