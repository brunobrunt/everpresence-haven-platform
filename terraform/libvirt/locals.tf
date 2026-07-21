# Local values are reusable values defined inside this Terraform project.
#
# Unlike input variables, users do not normally supply local values when
# running Terraform. They are used to organize information and reduce
# repetition within the configuration.
#
# This local value contains the inventory for the five VMs we are
# provisioning during the first phase:
#
# - Three Kubernetes control-plane nodes
# - Two Kubernetes worker nodes
#
# A third worker node will be added later as a horizontal-scaling exercise.

locals {
  nodes = {
    # ---------------------------------------------------------
    # Kubernetes control-plane nodes
    # ---------------------------------------------------------

    eph-cp01 = {
      role          = "control-plane"
      ip_address    = "172.16.10.31"
      mac_address   = "52:54:00:10:00:31"
      vcpu          = 2
      memory_mib    = 4096
      disk_size_gib = 40
    }

    eph-cp02 = {
      role          = "control-plane"
      ip_address    = "172.16.10.32"
      mac_address   = "52:54:00:10:00:32"
      vcpu          = 2
      memory_mib    = 4096
      disk_size_gib = 40
    }

    eph-cp03 = {
      role          = "control-plane"
      ip_address    = "172.16.10.33"
      mac_address   = "52:54:00:10:00:33"
      vcpu          = 2
      memory_mib    = 4096
      disk_size_gib = 40
    }

    # ---------------------------------------------------------
    # Kubernetes worker nodes
    # ---------------------------------------------------------

    eph-worker01 = {
      role          = "worker"
      ip_address    = "172.16.10.34"
      mac_address   = "52:54:00:10:00:34"
      vcpu          = 2
      memory_mib    = 8192
      disk_size_gib = 60
    }

    eph-worker02 = {
      role          = "worker"
      ip_address    = "172.16.10.35"
      mac_address   = "52:54:00:10:00:35"
      vcpu          = 2
      memory_mib    = 8192
      disk_size_gib = 60
    }
  }
}

# Reserved for a future scaling exercise:
#
# VM name:       eph-worker03
# IP address:    172.16.10.36
# MAC address:   52:54:00:10:00:36
# vCPU:          2
# Memory:        8192 MiB
# Disk:          60 GiB
#
# The third worker is not included in local.nodes yet, so Terraform
# will not create it during the initial deployment.
