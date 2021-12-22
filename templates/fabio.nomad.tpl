job "fabio" {
  datacenters = ["dc1", "dc2"]
  type = "system"

  group "fabio" {
    network {
      port "lb" {
        static = 10000
      }
      port "ui" {
        static = 10001
      }
    }
    task "fabio" {
      driver = "ch"
      config {
        image = "fabiolb/fabio"
        ports = ["lb","ui"]
      }
      env {
        FABIO_REGISTRY_CONSUL_ADDR = "${CONSUL_REGISTRY_ADDR}"
        FABIO_REGISTRY_CONSUL_TAGPREFIX="$${node.unique.name}-urlprefix-"
        FABIO_PROXY_ADDR = ":10000"
	FABIO_UI_ADDR = ":10001"
      }

      resources {
        cpu    = 500
        memory = 500
      }
    }
  }
}
