resource "nomad_job" "fabio" {
  hcl2 {
    enabled = true
    vars = {
    }
  }

  jobspec = templatefile("${path.module}/templates/fabio.nomad.tpl", {
    CONSUL_REGISTRY_ADDR = "http://${hsdp_container_host.nomad_server.private_ip}:4040"
  })

  depends_on = [cloudfoundry_app.nomad_proxy]
}
