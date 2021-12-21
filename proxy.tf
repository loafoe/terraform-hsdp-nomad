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
      upstream_host    = hsdp_container_host.nomad_server.private_ip
      upstream_port    = "8282"
      fabio_proxy_port = "10000"
      fabio_ui_port    = "10001"
      nomad_host       = cloudfoundry_route.nomad.endpoint
      fabio_ui_host    = cloudfoundry_route.fabio_ui.endpoint
      fabio_host       = cloudfoundry_route.fabio.endpoint
    }))
  }, {})

  command = "echo $ENVOYCONFIG_BASE64 | base64 -d > /etc/envoy/envoy.yaml && cat /etc/envoy/envoy.yaml && /usr/local/bin/envoy -c /etc/envoy/envoy.yaml --base-id 42"
  #health_check_type = "process"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.nomad.id
  }
  routes {
    route = cloudfoundry_route.fabio_ui.id
  }
  routes {
    route = cloudfoundry_route.fabio.id
  }
  routes {
    route = cloudfoundry_route.test.id
  }
  routes {
    route = cloudfoundry_route.grafana.id
  }

}

resource "cloudfoundry_route" "nomad" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "nomad-${random_pet.deploy.id}"
}

resource "cloudfoundry_route" "fabio_ui" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "fabio-ui-${random_pet.deploy.id}"
}

resource "cloudfoundry_route" "fabio" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "fabio-${random_pet.deploy.id}"
}

resource "cloudfoundry_route" "test" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "test-${random_pet.deploy.id}"
}

resource "cloudfoundry_route" "grafana" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = data.cloudfoundry_space.space.id
  hostname = "grafana-${random_pet.deploy.id}"
}

