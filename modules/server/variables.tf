variable "name" {
  type = string
}

variable "datacenter" {
  type = string
}

variable "region" {
  type = string
}

variable "ldap_user" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_groups" {
  type = list(string)
}

variable "user" {
  type = string
}

variable "nomad_image" {
  type = string
}

variable "consul_image" {
  type = string
}

variable "docker_runtime" {
  type = string
}

variable "hostname_postfix" {
  type = string
}
