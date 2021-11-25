resource "cloudfoundry_app" "nomad_proxy" {
  name         = "tf-nomad-proxy"
  space        = data.cloudfoundry_space.space.id
  memory       = 128
  disk_quota   = 512
  docker_image = "caddy"

  environment = merge({
    CADDYFILE_BASE64 = base64encode(templatefile("${path.module}/templates/Caddyfile", {
      upstream_url = "http://${hsdp_container_host.nomad.private_ip}:8282"
    }))
  }, {})

  command           = "echo $CADDYFILE_BASE64 | base64 -d > /etc/caddy/Caddyfile && cat /etc/caddy/Caddyfile && caddy run -config /etc/caddy/Caddyfile"
  health_check_type = "process"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.nomad_proxy.id
  }
}

resource "cloudfoundry_route" "nomad_proxy" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "${random_pet.deploy.id}-proxy"
}
