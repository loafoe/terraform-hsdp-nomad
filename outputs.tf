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
  value = hsdp_container_host_exec.nomad_server_init.result
}

output "consul_server_bootstrap" {
  value = hsdp_container_host_exec.consul_server_init.result
}

output "secret_id" {
  value = local.secret_id
}
