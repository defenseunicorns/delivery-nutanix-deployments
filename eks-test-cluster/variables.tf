# Copyright 2024 Defense Unicorns
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial

variable "kubeconfig" {
  description = "Path to the kubeconfig to use for using the kubernetes provider. Should be a config for an eks-a management cluster."
  type        = string
}

variable "node_ssh_keys" {
  description = "List of SSH public keys for nodes to trust for SSH access."
  type        = list(string)
}
