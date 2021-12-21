resource "hsdp_container_host" "nomad_node" {
  name                        = "${var.name}.dev"
  volumes                     = 1
  volume_size                 = 100
  instance_type               = var.instance_type
  user_groups                 = var.user_groups
  security_groups             = ["analytics"]
  user                        = var.user
  commands_after_file_changes = true
  agent                       = true

  tags = {
    created_by = var.user
  }
  keep_failed_instances = false
}

resource "hsdp_container_host_exec" "init_nomad" {
  host  = hsdp_container_host.nomad_node.private_ip
  user  = var.user
  agent = true

  file {
    content = templatefile("${path.module}/templates/node.hcl", {
      servers          = ["${var.server_ip}:8181"]
      advertise_ip     = hsdp_container_host.nomad_node.private_ip
      consul_server_ip = var.server_ip
      region           = "global"
      datacenter       = "dc2"
      name             = var.name
      docker_runtime   = var.docker_runtime
    })
    destination = "/home/${var.user}/client.hcl"
    permissions = "0755"
  }

  commands = [
    "docker stop nomad || true",
    "docker rm nomad || true",
    "docker rm alpine || true",
    "docker volume rm nomad-config || true",
    "docker volume create nomad-config",
    "docker network create nomad || true",
    "docker create -v nomad-config:/config --name alpine alpine",
    "docker cp /home/${var.user}/client.hcl alpine:/config",
    "docker run -d --restart on-failure --name nomad -v nomad-config:/config -p48862:48862 -p8282:8282 -e HOSTNAME_POSTFIX=${var.hostname_postfix} -e CONSUL_REGISTRY_ADDR=http://${hsdp_container_host.nomad_node.private_ip}:4040 -e NOMAD_ADDR=http://127.0.0.1:8282 -e DOCKER_HOST=tcp://${hsdp_container_host.nomad_node.private_ip}:2375 ${var.nomad_image} nomad agent -client -bind=0.0.0.0 -acl-enabled -plugin-dir=/plugins -config=/config/client.hcl -data-dir=/tmp/nomad",
  ]
}
