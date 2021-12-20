client {
  enabled = true
  options = {
    "driver.allowlist" = "ch"
  }
}

server {
  enabled          = true
  bootstrap_expect = 1
}

advertise {
  http = "${advertise_ip}"
  rpc  = "${advertise_ip}"
  serf = "${advertise_ip}"
}

ports {
  http = 8282
  rpc  = 8181
  serf = 48862
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}

consul {
  address = "${advertise_ip}:4040"
  checks_use_advertise = true
}

plugin "nomad-driver-ch" {
  config {
    enabled = true
    runtime = "${docker_runtime}"
  }
}

name = "${name}"
region = "${region}"
datacenter = "${datacenter}"
