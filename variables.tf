variable "cf_user" {
  type = string
}

variable "cf_password" {
  type = string
}

variable "cf_org_name" {
  type = string
}

variable "cf_space_name" {
  type = string
}

variable "region" {
  type = string
}

variable "eu_cartel_token" {
  type = string
}

variable "eu_cartel_secret" {
  type = string
}

variable "us_cartel_token" {
  type = string
}

variable "us_cartel_secret" {
  type = string
}


variable "private_key_file" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "volume_size" {
  type    = number
  default = 50
}
