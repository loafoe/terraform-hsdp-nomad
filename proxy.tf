resource "cloudfoundry_app" "nomad_proxy" {
  name         = "tf-nomad-proxy"
  space        = data.cloudfoundry_space.space.id
  memory       = 128
  disk_quota   = 512
  docker_image = "envoyproxy/envoy-alpine:v1.20-latest"
  strategy     = "blue-green"
  instances    = 8

  environment = merge({
    ENVOYCONFIG_BASE64 = base64encode(templatefile("${path.module}/templates/envoy.yaml", {
      upstream_host = hsdp_container_host.nomad_server.private_ip
      upstream_port = "8282"
    }))
  }, {})

  command = "echo $ENVOYCONFIG_BASE64 | base64 -d > /etc/envoy/envoy.yaml && cat /etc/envoy/envoy.yaml && /usr/local/bin/envoy -c /etc/envoy/envoy.yaml --base-id 42"
  #health_check_type = "process"

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
