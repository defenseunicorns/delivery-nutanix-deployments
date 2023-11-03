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
