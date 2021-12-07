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

region = "${region}"
datacenter = "${datacenter}"
