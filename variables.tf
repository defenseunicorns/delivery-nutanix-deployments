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

variable "nutanix_cluster" {
  description = "The name of the Nutanix cluster to deploy to."
  type        = string
}

variable "nutanix_subnet" {
  description = "The name of the subnet to deploy VMs to."
  type        = string
}

variable "image_name" {
  description = "The name of the image to use for virtual machines."
  type        = string
}

variable "server_primary_disk_size" {
  description = "The size of the primary disk for server VMs in MiB. Primary disk is the boot disk and contains ephemeral storage."
  type        = number
  default     = 150 * 1024
}

variable "server_secondary_disk_size" {
  description = "The size of the secondary disk for server VMs in MiB. Secondary disk is used for PVC/object storage with rook/ceph."
  type        = number
  default     = 300 * 1024
}

variable "agent_primary_disk_size" {
  description = "The size of the primary disk for agent VMs in MiB. Primary disk is the boot disk and contains ephemeral storage."
  type        = number
  default     = 150 * 1024
}

variable "agent_secondary_disk_size" {
  description = "The size of the secondary disk for agent VMs in MiB. Secondary disk is used for PVC/object storage with rook/ceph."
  type        = number
  default     = 300 * 1024
}

variable "ssh_authorized_keys" {
  description = "A list of authorized public SSH keys to allow for login to the default user on all rke2 nodes"
  type        = list(string)
}
