terraform {
  required_providers {
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.27.5"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.15.0"
    }
    nomad = {
      source  = "hashicorp/nomad"
      version = ">= 1.4.16"
    }
  }
}
