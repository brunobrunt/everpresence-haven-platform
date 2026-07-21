# This file creates cloud-init configuration media for every VM.
#
# Cloud-init will use this media during the VM's first boot to configure:
#
# - Hostname and fully qualified domain name
# - Administrative user
# - SSH public-key access
# - Timezone
# - Baseline packages
# - Root filesystem expansion
# - Static network configuration
#
# Two resources are created for every node:
#
# 1. libvirt_cloudinit_disk.node
#    Renders the user-data, meta-data and network-config files into
#    a temporary local cloud-init disk.
#
# 2. libvirt_volume.cloudinit_iso
#    Uploads that generated disk into the eph-k8s storage pool as
#    an ISO volume that can be attached to the VM.


# ---------------------------------------------------------
# Generate cloud-init disks
# ---------------------------------------------------------

resource "libvirt_cloudinit_disk" "node" {
  # Create one cloud-init disk for every VM in local.nodes.
  for_each = local.nodes

  # Name of the generated cloud-init disk.
  name = "${each.key}-cloudinit"

  # Render the user-data template for the current node.
  #
  # templatefile() reads the template and replaces its placeholders
  # with the values supplied in this map.
  user_data = templatefile(
    "${path.module}/templates/user-data.yaml.tftpl",
    {
      hostname       = each.key
      domain_name    = var.domain_name
      node_role      = each.value.role
      ssh_user       = var.ssh_user
      ssh_public_key = trimspace(file(pathexpand(var.ssh_public_key_path)))
      timezone       = var.timezone
    }
  )

  # Meta-data gives cloud-init a unique identity for this VM.
  #
  # A unique instance-id is important because cloud-init uses it to
  # determine whether this is a new machine that requires first-boot
  # configuration.
  meta_data = yamlencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })

  # Render the static network configuration for the current VM.
  network_config = templatefile(
    "${path.module}/templates/network-config.yaml.tftpl",
    {
      mac_address    = each.value.mac_address
      ip_address     = each.value.ip_address
      network_prefix = var.network_prefix
      gateway        = var.gateway
      dns_servers    = var.dns_servers
      domain_name    = var.domain_name
    }
  )
}


# ---------------------------------------------------------
# Upload cloud-init ISOs to the libvirt storage pool
# ---------------------------------------------------------

resource "libvirt_volume" "cloudinit_iso" {
  # Create one ISO volume for every generated cloud-init disk.
  for_each = local.nodes

  # The volume names will look like:
  #
  # eph-cp01-cloudinit.iso
  # eph-worker01-cloudinit.iso
  name = "${each.key}-cloudinit.iso"

  # Store the ISO in the Terraform-managed eph-k8s pool.
  pool = libvirt_pool.eph_k8s.name

  # Upload the locally generated cloud-init disk into libvirt.
  #
  # This reference also creates an implicit dependency:
  #
  # libvirt_cloudinit_disk.node must be generated before the
  # corresponding libvirt volume can be uploaded.
  create = {
    content = {
      url = libvirt_cloudinit_disk.node[each.key].path
    }
  }
}
