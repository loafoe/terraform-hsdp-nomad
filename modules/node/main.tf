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
  keep_failed_instances = true
}

resource "hsdp_container_host_exec" "init_nomad" {
  host  = hsdp_container_host.nomad_node.private_ip
  user  = var.user
  agent = true

  file {
    content = templatefile("${path.module}/templates/node.hcl", {
      servers      = ["${var.server_ip}:8181"]
      advertise_ip = hsdp_container_host.nomad_node.private_ip
      region       = "global"
      datacenter   = "dc2"
      name         = var.name
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
    "docker create -v nomad-config:/config --name alpine alpine",
    "docker cp /home/${var.user}/client.hcl alpine:/config",
    "docker run -d --name nomad -v nomad-config:/config -p8282:8282 -e NOMAD_ADDR=http://127.0.0.1:8282 -e DOCKER_HOST=tcp://${hsdp_container_host.nomad_node.private_ip}:2375 ${var.nomad_image} /app/nomad agent -client -bind=0.0.0.0 -acl-enabled -plugin-dir=/plugins -config=/config/client.hcl -data-dir=/tmp/nomad",
  ]
}