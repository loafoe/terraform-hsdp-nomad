provider "hsdp" {
  region        = var.region
  debug_log     = "/tmp/nomad-us-east.log"
  uaa_username  = var.cf_user
  uaa_password  = var.cf_password
  cartel_token  = local.cartel_token
  cartel_secret = local.cartel_secret
}

provider "cloudfoundry" {
  api_url  = data.hsdp_config.cf.url
  user     = var.cf_user
  password = var.cf_password
}

provider "nomad" {
  address   = local.nomad_addr
  secret_id = local.secret_id
}
