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

consul {
  address = "${advertise_ip}:4040"
  checks_use_advertise = true
}

name = "${name}"
region = "${region}"
datacenter = "${datacenter}"
