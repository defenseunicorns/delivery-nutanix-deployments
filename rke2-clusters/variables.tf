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

variable "green_image_name" {
  description = "The name of the image to use for virtual machines."
  type        = string
  default     = ""
}

variable "ssh_authorized_keys" {
  description = "A list of authorized public SSH keys to allow for login to the default user on all rke2 nodes"
  type        = list(string)
}

variable "dev_server_dns" {
  description = "The DNS name to use for the server/controlplane. Should route round robin to all rke2 server nodes"
  type        = string
  default     = ""
}

variable "test_server_dns" {
  description = "The DNS name to use for the server/controlplane. Should route round robin to all rke2 server nodes"
  type        = string
  default     = ""
}

variable "dev_server_ip_list" {
  description = "Optional list of static IPs for server nodes. List must be >= server_count if used. If unused, server nodes will use DHCP."
  type        = list(string)
  default     = []
}

variable "test_server_ip_list" {
  description = "Optional list of static IPs for server nodes. List must be >= server_count if used. If unused, server nodes will use DHCP."
  type        = list(string)
  default     = []
}

variable "green_test_server_ip_list" {
  description = "Optional list of static IPs for server nodes. List must be >= server_count if used. If unused, server nodes will use DHCP."
  type        = list(string)
  default     = []
}

variable "ntp_server" {
  description = "IP to use for NTP"
  type        = string
  default     = ""
}
