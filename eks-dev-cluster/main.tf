terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.32.0"
    }
  }
  backend "s3" {
    bucket    = "tofu-state"
    key       = "eks-dev-cluster/terraform.tfstate"
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

provider "kubernetes" {
  config_path    = var.kubeconfig
}

module eksa-dev-cluster {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/eks-d?ref=v0.4.1"

  cluster_name = "dev"
  control_plane_cert_sans = ["kube-dev.mtsi.bigbang.dev", "10.0.200.40"]
  control_plane_host = "10.0.200.40"
  kube_version = "1.29"
  registry_mirror_host = "10.0.20.238"
  registry_mirror_insecure = true
  prism_central_endpoint = "10.0.20.10"
  prism_central_insecure = true
  nutanix_cluster_name = "DU-Prod"
  node_image_name = "eks-rhel-node-image-1.29-v2"
  nutanix_subnet_name = "AirGap-Management-GC2"
  node_ssh_keys = var.node_ssh_keys
  cp_node_memory = "16Gi"
  cp_node_cpu_count = 8
  etcd_node_memory = "8Gi"
  etcd_node_cpu_count = 4
  compute_node_memory = "64Gi"
  compute_node_cpu_count = 32
  gitaly_node_memory = "70Gi"
  gitaly_node_cpu_count = 20
}