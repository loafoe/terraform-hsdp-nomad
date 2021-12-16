data_dir = "/consul"

datacenter = "${datacenter}"

server = true

bootstrap_expect = 1

ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

connect {
  enabled = true
}

ports {
  http     = 4040
  dns      = 4041
  server   = 8020
  serf_lan = 6066

  sidecar_min_port = 8090
  sidecar_max_port = 8099

  expose_min_port = 7077
  expose_max_port = 7078 
}

advertise_addr = "${advertise_ip}"

enable_central_service_config = true
