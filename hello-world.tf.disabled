resource "nomad_job" "hello_world" {
  hcl2 {
    enabled = true
    vars = {
    }
  }

  jobspec = templatefile("${path.module}/templates/hello-world.nomad.tpl", {
    CONSUL_REGISTRY_ADDR = "http://${hsdp_container_host.nomad_server.private_ip}:4040"
  })

  depends_on = [cloudfoundry_app.nomad_proxy]
}
