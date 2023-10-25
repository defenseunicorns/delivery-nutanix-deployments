
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

/*
This deployment example can be forked/copied and modified for a specific environment.
As is it references the delivery-nutanix-iac in github and uses the same input variables for
2 different clusters. This would create both clusters in the same Nutanix subnet, using the
same image, and configuring both clusters with the same SSH keys on all nodes.

In a real environment you should create as many module blocks as needed for the number
of clusters that are needed, and each should be provided separate sets of SSH keys.
Depending on networking requirements, they might also need to be deployed to deifferent
Nutanix subnets, or even different Nutanix clusters. This example is only meant to show
how the delivery nutanix rke2 module can be referenced. See the module input vars for
all available options.
*/

module "test-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=v0.0.1"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-test"
  server_count        = 3
  agent_count         = 3
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = var.image_name
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = var.test_server_dns
  server_ip_list      = var.test_server_ip_list
}

module "dev-cluster" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/rke2?ref=v0.0.1"

  nutanix_cluster     = var.nutanix_cluster
  nutanix_subnet      = var.nutanix_subnet
  name                = "rke2-dev"
  server_count        = 3
  agent_count         = 3
  server_memory       = 16*1024
  server_cpu          = 8
  agent_memory        = 64*1024
  agent_cpu           = 16
  image_name          = var.image_name
  ssh_authorized_keys = var.ssh_authorized_keys
  server_dns_name     = var.dev_server_dns
  server_ip_list      = var.dev_server_ip_list
}
