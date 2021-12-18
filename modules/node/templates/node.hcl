client {
  options = {
    "driver.allowlist" = "ch"
  }
  servers = [
    %{ for server in servers ~}
        "${server}",
    %{ endfor ~}
  ]
  server_join {
    retry_max = 10
    retry_interval = "10s"
  }
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
  address = "${advertise_ip}:4040"
  checks_use_advertise = true
}

name = "${name}"
region = "${region}"
datacenter = "${datacenter}"
