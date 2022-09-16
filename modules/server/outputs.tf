output "private_ip" {
  value = hsdp_container_host.nomad_server.private_ip
}

output "nomad_result" {
  value = ssh_resource.nomad_server_init.result
}

output "consul_result" {
  value = ssh_resource.consul_server_init.result
}

