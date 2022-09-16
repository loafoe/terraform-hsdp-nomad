resource "ssh_resource" "consul_server_init" {
  host  = hsdp_container_host.nomad_server.private_ip
  user  = var.ldap_user
  agent = true

  bastion_host = data.hsdp_config.gw.host

  file {
    content = templatefile("${path.module}/templates/consul-server.hcl", {
      advertise_ip = hsdp_container_host.nomad_server.private_ip
      datacenter   = "dc1"
      name         = "server"
    })
    destination = "/home/${var.ldap_user}/consul-server.hcl"
    permissions = "0755"
  }

  commands = [
    "docker stop consul-server || true",
    "docker rm consul-server || true",
    "docker rm consul-alpine || true",
    "docker volume rm consul-server-config || true",
    "docker volume create consul-server-config || true",
    "docker volume create consul-server-data || true",
    "docker create -v consul-server-config:/config --name consul-alpine alpine",
    "docker cp /home/${var.ldap_user}/consul-server.hcl consul-alpine:/config/consul-server.hcl",
    "docker run -d -l nomad_ignore=true --restart on-failure --name consul-server -v consul-server-data:/consul -v consul-server-config:/config -p4040:4040 -p4041:4041 -p8020:8020 -p6066:6066 ${var.consul_image} consul agent -config-file=/config/consul-server.hcl"
  ]
}
