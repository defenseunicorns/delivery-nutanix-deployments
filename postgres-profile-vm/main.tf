
terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 1.9.0"
    }
  }
}

provider "nutanix" {
  username = var.nutanix_username
  password = var.nutanix_password
  endpoint = var.nutanix_endpoint
  port     = var.nutanix_port
  insecure = var.nutanix_insecure
}

module "postgres-14-profile-vm" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/postgres-profile-vm?ref=v0.2.2"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "postgres-14-profile"
  memory              = 16*1024
  image_name          = var.image_name
  ssh_authorized_keys = var.ssh_authorized_keys
  user_password       = var.user_password
  pg_password         = var.pg_password
}
