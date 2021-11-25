locals {
  cartel_token  = var.region == "us-east" ? var.us_cartel_token : var.eu_cartel_token
  cartel_secret = var.region == "us-east" ? var.us_cartel_secret : var.eu_cartel_secret
}

resource "random_pet" "deploy" {
}

resource "hsdp_container_host" "terraform" {
  name                        = "${random_pet.deploy.id}.dev"
  volumes                     = 1
  volume_size                 = 100
  instance_type               = var.instance_type
  user_groups                 = [var.cf_user]
  security_groups             = ["analytics"]
  user                        = var.cf_user
  commands_after_file_changes = true
  agent                       = true

  tags = {
    created_by = var.cf_user
  }
  keep_failed_instances = true
}

resource "hsdp_container_host_exec" "init" {
  host  = hsdp_container_host.terraform.private_ip
  user  = var.cf_user
  agent = true

  commands = [
    "docker run -d --name nomad -p8282:4646 -e DOCKER_HOST=tcp://${hsdp_container_host.terraform.private_ip}:2375 loafoe/nomad /app/nomad agent -dev -bind=0.0.0.0",
    "docker ps"
  ]
}

output "services" {
  value = data.hsdp_config.cf.services
}
