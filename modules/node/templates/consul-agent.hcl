data_dir = "/tmp/consul"

datacenter = "dc1"

ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  http     = 4040
  dns      = 4041
  server   = 8020
  serf_lan = 6066
}

advertise_addr = "${advertise_ip}"

retry_join = ["${consul_server_ip}:6066"]
