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
}

consul {
  address = "172.17.0.1:8500"
}

name = "${name}"
region = "${region}"
datacenter = "${datacenter}"
