resource "hsdp_container_host_exec" "consul_agent_init" {
  host  = hsdp_container_host.nomad_node.private_ip
  user  = var.user
  agent = true

  file {
    content = templatefile("${path.module}/templates/consul-agent.hcl", {
      advertise_ip     = hsdp_container_host.nomad_node.private_ip
      datacenter       = "dc1"
      name             = "agent"
      consul_server_ip = var.server_ip
    })
    destination = "/home/${var.user}/consul-agent.hcl"
    permissions = "0755"
  }

  commands = [
    "docker stop consul-agent || true",
    "docker rm consul-agent || true",
    "docker rm consul-agent-alpine || true",
    "docker volume rm consul-agent-config || true",
    "docker volume create consul-agent-config || true",
    "docker volume create consul-agent-data || true",
    "docker create -v consul-agent-config:/config --name consul-agent-alpine alpine",
    "docker cp /home/${var.user}/consul-agent.hcl consul-agent-alpine:/config/consul-agent.hcl",
    "docker run -d -l nomad_ignore=true --restart on-failure --name consul-agent -v consul-agent-data:/consul -v consul-agent-config:/config -p4040:4040 -p4041:4041 -p8020:8020 -p6066:6066 ${var.consul_image} consul agent -config-file=/config/consul-agent.hcl"
  ]
}
