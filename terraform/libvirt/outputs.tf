#Outputs make important infrastructure details easy to retrieve without searching through locals.tf or Terraform state.
#
# Terraform outputs display useful information after provisioning.
#
# Outputs do not create infrastructure. They expose selected values
# from the Terraform configuration and state.


# ---------------------------------------------------------
# Complete node inventory
# ---------------------------------------------------------

output "node_inventory" {
  description = "Names, roles and IP addresses of all initial Kubernetes nodes"

  value = {
    for name, node in local.nodes :
    name => {
      role       = node.role
      ip_address = node.ip_address
    }
  }
}


# ---------------------------------------------------------
# Control-plane nodes
# ---------------------------------------------------------

output "control_plane_nodes" {
  description = "IP addresses of the Kubernetes control-plane nodes"

  value = {
    for name, node in local.nodes :
    name => node.ip_address
    if node.role == "control-plane"
  }
}


# ---------------------------------------------------------
# Worker nodes
# ---------------------------------------------------------

output "worker_nodes" {
  description = "IP addresses of the Kubernetes worker nodes"

  value = {
    for name, node in local.nodes :
    name => node.ip_address
    if node.role == "worker"
  }
}


# ---------------------------------------------------------
# SSH commands
# ---------------------------------------------------------

output "ssh_commands" {
  description = "SSH commands for connecting to every VM"

  value = {
    for name, node in local.nodes :
    name => "ssh -i ~/.ssh/eph_k8s ${var.ssh_user}@${node.ip_address}"
  }
}

# ---------------------------------------------------------
# Kubernetes API endpoint
# ---------------------------------------------------------

output "kubernetes_api_endpoint" {
  description = "Reserved virtual IP and port for the Kubernetes API"

  value = "https://${var.api_vip}:6443"
}


# ---------------------------------------------------------
# Libvirt storage information
# ---------------------------------------------------------

output "storage_pool" {
  description = "Libvirt storage pool used by the Kubernetes VMs"

  value = {
    name = libvirt_pool.eph_k8s.name
    path = var.storage_pool_path
  }
}


# ---------------------------------------------------------
# Reserved future worker
# ---------------------------------------------------------

output "future_worker" {
  description = "Reserved configuration for the future third worker node"

  value = {
    name       = "eph-worker03"
    ip_address = "172.16.10.36"
    status     = "Reserved for future horizontal scaling"
  }
}
