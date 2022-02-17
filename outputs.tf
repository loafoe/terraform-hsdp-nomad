output "nomad" {
  value = local.nomad_addr
}

output "fabio_ui" {
  value = "https://${cloudfoundry_route.fabio_ui.endpoint}"
}

output "fabio" {
  value = "https://${cloudfoundry_route.fabio.endpoint}"
}

output "nomad_server_bootstrap" {
  value = module.nomad_server.nomad_result
}

output "consul_server_bootstrap" {
  value = module.nomad_server.consul_result
}

output "secret_id" {
  value = local.secret_id
}
