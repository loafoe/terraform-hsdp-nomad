output "nomad_proxy" {
  value = "https://${cloudfoundry_route.nomad_proxy.endpoint}"
}

output "nomad_bootstrap" {
  value = hsdp_container_host_exec.init.result
}
