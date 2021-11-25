data "hsdp_config" "cf" {
  region  = var.region
  service = "cf"
}

data "cloudfoundry_domain" "domain" {
  name = data.hsdp_config.cf.domain
}

data "cloudfoundry_org" "org" {
  name = var.cf_org_name
}

data "cloudfoundry_space" "space" {
  org  = data.cloudfoundry_org.org.id
  name = var.cf_space_name
}
