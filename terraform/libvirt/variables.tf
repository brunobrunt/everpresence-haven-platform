variable "libvirt_uri" {
  description = "Connection URI for the system-wide libvirt daemon"
  type        = string
  default     = "qemu:///system"
}

variable "storage_pool_name" {
  description = "Name of the libvirt storage pool for the Kubernetes VMs"
  type        = string
  default     = "eph-k8s"
}

variable "storage_pool_path" {
  description = "Filesystem path where the Kubernetes VM disks will be stored"
  type        = string
}

variable "base_image_path" {
  description = "Path to the Ubuntu 24.04 QCOW2 cloud image"
  type        = string
}

variable "ssh_user" {
  description = "Administrative Linux user created on each VM"
  type        = string
  default     = "mino"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key installed on each VM"
  type        = string
}

variable "network_name" {
  description = "Existing libvirt network to which the VMs will be connected"
  type        = string
  default     = "default"
}

variable "network_prefix" {
  description = "CIDR prefix length for the VM network"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "Default gateway used by the Kubernetes VMs"
  type        = string
  default     = "172.16.10.1"
}

variable "dns_servers" {
  description = "DNS servers assigned to the Kubernetes VMs"
  type        = list(string)

  default = [
    "1.1.1.1",
    "8.8.8.8"
  ]
}

variable "domain_name" {
  description = "Internal DNS domain used by the Kubernetes nodes"
  type        = string
  default     = "everpresencehaven.internal"
}

variable "api_vip" {
  description = "Reserved virtual IP for the highly available Kubernetes API"
  type        = string
  default     = "172.16.10.30"
}

variable "timezone" {
  description = "Timezone configured on the virtual machines"
  type        = string
  default     = "America/Edmonton"
}
