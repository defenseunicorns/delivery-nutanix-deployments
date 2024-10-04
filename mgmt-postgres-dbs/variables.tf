variable "nutanix_username" {
  description = "The username used to authenticate with Prism Central."
  type        = string
}

variable "nutanix_password" {
  description = "The password used to authenticate with Prism Central."
  type        = string
}

variable "nutanix_endpoint" {
  description = "The endpoint URL for Prism Central."
  type        = string
}

variable "nutanix_port" {
  description = "The port to use when connecting to Prism Central."
  type        = number
  default     = 9440
}

variable "nutanix_insecure" {
  description = "Set to true to disable SSL certificate validation, false by default."
  type        = bool
  default     = false
}

variable "ndb_username" {
  description = "The username used to authenticate with NDB."
  type        = string
}

variable "ndb_password" {
  description = "The password used to authenticate with NDB."
  type        = string
}

variable "ndb_endpoint" {
  description = "The endpoint URL for NDB."
  type        = string
}

#NDB settings

#Database settings

variable "gitlab_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "keycloak_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "sonarqube_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "jira_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "confluence_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "mattermost_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "nexus_db_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

# VM settings

variable "nutanix_cluster_name" {
  description = "The name of the Nutanix cluster to deploy to."
  type        = string
}

variable "ssh_authorized_key" {
  description = "An SSH public key to allow for login to the era user on postgres databases"
  type        = string
}

variable "gitlab_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "keycloak_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "sonarqube_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "jira_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "confluence_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "mattermost_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}

variable "nexus_vm_password" {
  description = "The password to set for the postgres DB postgres user."
  type        = string
}