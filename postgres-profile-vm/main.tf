
terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 1.9.0"
    }
  }
  backend "s3" {
    bucket    = "tofu-state"
    key       = "postgres-profile-vm/terraform.tfstate"
    endpoints = { s3 = "https://swf.objects.mtsi.bigbang.dev" }
    region    = "us-east-1"

    shared_credentials_files    = ["~/.nutanix/credentials"]
    insecure                    = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
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
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/postgres-profile-vm?ref=v0.3.3"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "postgres-14-profile"
  memory              = 4 * 1024
  image_name          = var.image_name
  ssh_authorized_keys = var.ssh_authorized_keys
  user_password       = var.user_password
  pg_password         = var.pg_password
  ntp_server          = var.ntp_server
}
