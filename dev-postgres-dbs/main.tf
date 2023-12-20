locals {
  default_software_profile_name = "postgres_14.9"
  default_compute_profile_name  = "large-compute"
  default_network_profile_name  = "DEFAULT_OOB_POSTGRESQL_NETWORK"
  default_db_param_profile_name = "DEFAULT_POSTGRES_PARAMS"
  default_sla_name              = "DEFAULT_OOB_BRASS_SLA"
}

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

module "gitlab-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "gitlabdb"
  instance_name         = "dev-gitlab-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.gitlab_db_password
  vm_password           = var.gitlab_vm_password
}

module "keycloak-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "keycloakdb"
  instance_name         = "dev-keycloak-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.keycloak_db_password
  vm_password           = var.keycloak_vm_password
}

module "sonarqube-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "sonarqubedb"
  instance_name         = "dev-sonarqube-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.sonarqube_db_password
  vm_password           = var.sonarqube_vm_password
}

module "jira-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "jiradb"
  instance_name         = "dev-jira-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.jira_db_password
  vm_password           = var.jira_vm_password
}

module "confluence-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "confluencedb"
  instance_name         = "dev-confluence-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.confluence_db_password
  vm_password           = var.confluence_vm_password
}

module "mattermost-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "mattermostdb"
  instance_name         = "dev-mattermost-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.mattermost_db_password
  vm_password           = var.mattermost_vm_password
}

module "nexus-pg-db" {
  source = "git::https://github.com/defenseunicorns/delivery-nutanix-iac.git//modules/ndb-pg-db?ref=v0.1.2"

  software_profile_name = local.default_software_profile_name
  compute_profile_name  = local.default_compute_profile_name
  network_profile_name  = local.default_network_profile_name
  db_param_profile_name = local.default_db_param_profile_name
  sla_name              = local.default_sla_name
  nutanix_cluster_name  = var.nutanix_cluster_name
  database_name         = "nexusdb"
  instance_name         = "dev-nexus-pg"
  database_size         = "200"
  ssh_authorized_key    = var.ssh_authorized_key
  db_password           = var.nexus_db_password
  vm_password           = var.nexus_vm_password
}
