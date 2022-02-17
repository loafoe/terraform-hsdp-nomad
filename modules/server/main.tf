resource "hsdp_container_host" "nomad_server" {
  name                        = "${var.name}.dev"
  volumes                     = 1
  volume_size                 = 100
  instance_type               = var.instance_type
  user_groups                 = [var.ldap_user]
  security_groups             = ["analytics"]
  user                        = var.ldap_user
  commands_after_file_changes = true
  agent                       = true

  tags = {
    created_by = var.ldap_user
  }
  keep_failed_instances = false
}

resource "hsdp_container_host_exec" "nomad_server_init" {
  host  = hsdp_container_host.nomad_server.private_ip
  user  = var.ldap_user
  agent = true

  file {
    content = templatefile("${path.module}/templates/server.hcl", {
      advertise_ip   = hsdp_container_host.nomad_server.private_ip
      region         = "global"
      datacenter     = "dc1"
      name           = "server"
      docker_runtime = var.docker_runtime
    })
    destination = "/home/${var.ldap_user}/server.hcl"
    permissions = "0755"
  }

  // TODO: get rid of alpine dependency and use embedded nomad-copier
  commands = [
    "docker stop nomad-server || true",
    "docker rm nomad-server || true",
    "docker rm alpine || true",
    "docker volume rm nomad-server-config || true",
    "docker volume create nomad-server-config",
    "docker volume create nomad-server-data || true",
    "docker network create nomad || true",
    "docker create -v nomad-server-config:/config --name alpine alpine",
    "docker cp /home/${var.ldap_user}/server.hcl alpine:/config",
    "docker run -d -l nomad_ignore=true --restart on-failure --name nomad-server -v nomad-server-data:/nomad -v nomad-server-config:/config -p48862:48862 -p8282:8282 -p8181:8181 -e NOMAD_ADDR=http://${hsdp_container_host.nomad_server.private_ip}:8282 -e DOCKER_HOST=tcp://${hsdp_container_host.nomad_server.private_ip}:2375 -e CONSUL_REGISTRY_ADDR=http://${hsdp_container_host.nomad_server.private_ip}:4040 -e HOSTNAME_POSTFIX=${var.hostname_postfix} ${var.nomad_image} nomad agent -server -bind=0.0.0.0 -acl-enabled -plugin-dir=/plugins -config=/config/server.hcl -data-dir=/tmp/nomad",
    "sleep 5",
    "docker exec nomad-server nomad acl bootstrap"
  ]
}
