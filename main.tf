locals {
  cartel_token  = var.region == "us-east" ? var.us_cartel_token : var.eu_cartel_token
  cartel_secret = var.region == "us-east" ? var.us_cartel_secret : var.eu_cartel_secret
}

resource "random_pet" "deploy" {
}

