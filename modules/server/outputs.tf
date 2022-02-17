output "private_ip" {
  value = hsdp_container_host.nomad_server.private_ip
}

output "nomad_result" {
  value = hsdp_container_host_exec.nomad_server_init.result
}

output "consul_result" {
  value = hsdp_container_host_exec.consul_server_init.result
}

