
terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 1.9.0"
    }
  }
  backend "s3" {
    bucket    = "tofu-state"
    key       = "eks-anywhere-admin/terraform.tfstate"
    endpoints = { s3 = "https://swf.objects.mtsi.bigbang.dev" }
    region    = "us-east-1"

    shared_credentials_files    = ["~/.nutanix/credentials"]
    insecure                    = true
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    # skip_metadata_api_check     = true
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


resource "random_string" "uid" {
  length  = 3
  special = false
  lower   = true
  upper   = false
  numeric = true
}

data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.nutanix_subnet
}

data "nutanix_image" "image" {
  image_name = var.image_name
}

data "nutanix_image" "nofips-image" {
  image_name = "rhel-8.9-base-image"
}

resource "nutanix_virtual_machine" "eks_anywhere_admin" {
  name         = "${random_string.uid.result}-eks-anywhere-admin"
  cluster_uuid = data.nutanix_cluster.cluster.id

  memory_size_mib      = 16 * 1024
  num_sockets          = 4
  num_vcpus_per_socket = 1

  boot_type = "UEFI"

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image.id
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
    disk_size_mib = 150 * 1024
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("${path.module}/cloud-config.tpl.yaml", {
    hostname         = "${random_string.uid.result}-eks-anywhere-admin",
    node_user        = "nutanix",
    authorized_keys  = var.ssh_authorized_keys,
    ntp_server       = var.ntp_server,
  }))
}

resource "nutanix_virtual_machine" "eks_anywhere_admin_2" {
  name         = "${random_string.uid.result}-eks-anywhere-admin-2"
  cluster_uuid = data.nutanix_cluster.cluster.id

  memory_size_mib      = 16 * 1024
  num_sockets          = 4
  num_vcpus_per_socket = 1

  boot_type = "UEFI"

  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.nofips-image.id
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
    disk_size_mib = 150 * 1024
  }

  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.id
  }

  guest_customization_cloud_init_user_data = base64encode(templatefile("${path.module}/cloud-config.tpl.yaml", {
    hostname         = "${random_string.uid.result}-eks-anywhere-admin-2",
    node_user        = "nutanix",
    authorized_keys  = var.ssh_authorized_keys,
    ntp_server       = var.ntp_server,
  }))
}

# module "anywhere-test" {
#   source = "../../delivery-nutanix-iac/modules/eks-anywhere-vm"

#   image_name = "eks-anywhere-bootstrap-image-v0.20.3-202410031457"
#   nutanix_subnet = var.nutanix_subnet
#   nutanix_cluster = var.nutanix_cluster
#   ssh_authorized_keys = var.ssh_authorized_keys
#   ntp_server = var.ntp_server
#   registry_mirror_host = "10.0.20.238"
#   registry_mirror_port = "5000"
#   nutanix_username = var.nutanix_username
#   nutanix_password = var.nutanix_password
# }
