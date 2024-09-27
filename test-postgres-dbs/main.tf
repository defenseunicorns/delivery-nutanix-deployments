locals {
  default_software_profile_name = "fips_postgres_14"
  default_compute_profile_name  = "large-compute"
  default_network_profile_name  = "DEFAULT_OOB_POSTGRESQL_NETWORK"
  default_db_param_profile_name = "tuned_postgres_profile"
  default_sla_name              = "DEFAULT_OOB_BRASS_SLA"
  name_prefix                   = "test-fips"
}

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 1.9.0"
    }
  }
  backend "s3" {
    bucket    = "tofu-state"
    key       = "test-postgres-dbs/terraform.tfstate"
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
  # NDB service configuration
  ndb_endpoint = var.ndb_endpoint
  ndb_username = var.ndb_username
  ndb_password = var.ndb_password
}

module "gitlab-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "gitlabdb"
  instance_name         = "${local.name_prefix}-gitlab-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.gitlab_db_password
  vm_password           = var.gitlab_vm_password
}

module "keycloak-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "keycloakdb"
  instance_name         = "${local.name_prefix}-keycloak-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.keycloak_db_password
  vm_password           = var.keycloak_vm_password
}

module "sonarqube-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "sonarqubedb"
  instance_name         = "${local.name_prefix}-sonarqube-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.sonarqube_db_password
  vm_password           = var.sonarqube_vm_password
}

module "jira-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "jiradb"
  instance_name         = "${local.name_prefix}-jira-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.jira_db_password
  vm_password           = var.jira_vm_password
}

module "confluence-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "confluencedb"
  instance_name         = "${local.name_prefix}-confluence-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.confluence_db_password
  vm_password           = var.confluence_vm_password
}

module "mattermost-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "mattermostdb"
  instance_name         = "${local.name_prefix}-mattermost-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.mattermost_db_password
  vm_password           = var.mattermost_vm_password
}

module "nexus-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.2.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "nexusdb"
  instance_name         = "${local.name_prefix}-nexus-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.nexus_db_password
  vm_password           = var.nexus_vm_password
}
