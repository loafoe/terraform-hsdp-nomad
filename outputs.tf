output "nomad_proxy" {
  value = "https://${cloudfoundry_route.nomad_proxy.endpoint}"
}

output "nomad_server_bootstrap" {
  value = hsdp_container_host_exec.nomad_server_init.result
}
