
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
  # NDB service configuration
  ndb_endpoint = var.ndb_endpoint
  ndb_username = var.ndb_username
  ndb_password = var.ndb_password
}

resource "nutanix_ndb_profile" "compute-profile-small" {
  name        = "small-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 2
    memory_size  = 2
  }
  published = true
}

resource "nutanix_ndb_profile" "compute-profile-medium" {
  name        = "medium-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 2
    memory_size  = 4
  }
  published = true
}

resource "nutanix_ndb_profile" "compute-profile-large" {
  name        = "large-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 2
    memory_size  = 8
  }
  published = true
}

resource "nutanix_ndb_profile" "compute-profile-xlarge" {
  name        = "xlarge-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 4
    memory_size  = 16
  }
  published = true
}

resource "nutanix_ndb_profile" "compute-profile-2xlarge" {
  name        = "2xlarge-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 8
    memory_size  = 32
  }
  published = true
}

resource "nutanix_ndb_profile" "compute-profile-4xlarge" {
  name        = "4xlarge-compute"
  description = "compute profile managed by terraform"
  compute_profile {
    core_per_cpu = 1
    cpus         = 16
    memory_size  = 64
  }
  published = true
}