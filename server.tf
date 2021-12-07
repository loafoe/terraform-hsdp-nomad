resource "hsdp_container_host" "nomad_server" {
  name                        = "${random_pet.deploy.id}-server.dev"
  volumes                     = 1
  volume_size                 = 100
  instance_type               = var.instance_type
  user_groups                 = [var.cf_user]
  security_groups             = ["analytics"]
  user                        = var.cf_user
  commands_after_file_changes = true
  agent                       = true

  tags = {
    created_by = var.cf_user
  }
  keep_failed_instances = false
}

resource "hsdp_container_host_exec" "nomad_server_init" {
  host  = hsdp_container_host.nomad_server.private_ip
  user  = var.cf_user
  agent = true

  file {
    content = templatefile("${path.module}/templates/server.hcl", {
      advertise_ip = hsdp_container_host.nomad_server.private_ip
      region = "global"
      datacenter = "dc1"
    })
    destination = "/home/${var.cf_user}/server.hcl"
    permissions = "0755"
  }

  commands = [
    "docker stop nomad-server || true",
    "docker rm nomad-server || true",
    "docker rm alpine || true",
    "docker volume rm nomad-server-config || true",
    "docker volume create nomad-server-config",
    "docker volume create nomad-server-data || true",
    "docker create -v nomad-server-config:/config --name alpine alpine",
    "docker cp /home/${var.cf_user}/server.hcl alpine:/config",
    "docker run -d --name nomad-server -v nomad-server-data:/nomad -v nomad-server-config:/config -p8282:8282 -p8181:8181 -e NOMAD_ADDR=http://127.0.0.1:8282 -e DOCKER_HOST=tcp://${hsdp_container_host.nomad_server.private_ip}:2375 ${var.nomad_image} /app/nomad agent -server -bind=0.0.0.0 -acl-enabled -plugin-dir=/plugins -config=/config/server.hcl -data-dir=/tmp/nomad",
    "sleep 5",
    "docker exec nomad-server /app/nomad acl bootstrap"
  ]
}
