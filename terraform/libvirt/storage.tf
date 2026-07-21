# Terraform address:  libvirt_pool.eph_k8s
# Libvirt pool name:  eph-k8s
# Host directory:     /data_all/libvirt/eph-k8s


# This file declares the storage resources used by the
# Ever Presence Haven Kubernetes virtual machines.
#
# We are building it in stages:
#
# 1. Create a libvirt storage pool.
# 2. Import the Ubuntu cloud image as a base volume.
# 3. Create one QCOW2 disk for each Kubernetes node.


# ---------------------------------------------------------
# Libvirt storage pool
# ---------------------------------------------------------

# A Terraform resource represents a real infrastructure object
# that Terraform will create and track.
#
# Resource type: libvirt_pool
# Local name:    eph_k8s
#
# Its full Terraform address is:
#
# libvirt_pool.eph_k8s

resource "libvirt_pool" "eph_k8s" {
  # The name that will appear in commands such as:
  #
  # virsh -c qemu:///system pool-list --all
  #
  # The value comes from variables.tf, where the default is eph-k8s.
  name = var.storage_pool_name

  # A directory-based pool stores its volumes as normal files
  # inside a directory on the physical host.
  type = "dir"

  # The host directory used by this storage pool.
  #
  # The actual value comes from terraform.tfvars:
  #
  # /data_all/libvirt/eph-k8s
  target = {
    path = var.storage_pool_path
  }
}

# ---------------------------------------------------------
# Ubuntu 24.04 base-image volume
# ---------------------------------------------------------

# This resource creates a Terraform-managed copy of the downloaded
# Ubuntu 24.04 cloud image inside the eph-k8s storage pool.
#
# The original image remains at:
#
# /home/alabi/images/ubuntu/ubuntu-24.04-server-cloudimg-amd64.img
#
# The managed copy will later serve as the backing image for
# the individual Kubernetes node disks.

resource "libvirt_volume" "ubuntu_base" {
  # The filename that will appear inside the libvirt storage pool.
  name = "ubuntu-24.04-base.qcow2"

  # Store this volume inside the pool created above.
  #
  # This reference also creates an implicit dependency:
  # Terraform must create the pool before creating the volume.
  pool = libvirt_pool.eph_k8s.name

  # The Ubuntu cloud image has a virtual capacity of approximately
  # 3.5 GiB. We assign 4 GiB to ensure the destination volume is
  # large enough to receive the image.
  #
  # The provider expects capacity in bytes.
  capacity = 4 * 1024 * 1024 * 1024

  # Define the destination volume as a QCOW2 image.
  target = {
    format = {
      type = "qcow2"
    }
  }

  # Upload the contents of the existing local cloud image into
  # this new libvirt volume.
  create = {
    content = {
      url = var.base_image_path
    }
  }
}

# ---------------------------------------------------------
# Kubernetes node disks
# ---------------------------------------------------------

# This resource uses for_each to create one disk for every
# virtual machine defined in local.nodes.
#
# local.nodes currently contains five entries:
#
# - eph-cp01
# - eph-cp02
# - eph-cp03
# - eph-worker01
# - eph-worker02
#
# Therefore, this single resource block creates five volumes.

resource "libvirt_volume" "node_disk" {
  # Repeat this resource once for each item in local.nodes.
  for_each = local.nodes

  # each.key represents the current node name.
  #
  # Examples:
  # eph-cp01.qcow2
  # eph-worker01.qcow2
  name = "${each.key}.qcow2"

  # Place every node disk inside the eph-k8s storage pool.
  pool = libvirt_pool.eph_k8s.name

  # disk_size_gib is stored in locals.tf using human-readable
  # GiB values such as 40 and 60.
  #
  # The libvirt provider expects capacity in bytes, so the
  # value is converted from GiB to bytes.
  capacity = each.value.disk_size_gib * 1024 * 1024 * 1024

  # Each node disk uses the Terraform-managed Ubuntu base
  # image as its backing store.
  #
  # This produces a copy-on-write QCOW2 overlay:
  #
  # - Common Ubuntu data is read from the base image.
  # - Changes made by each VM are written to its own disk.
  # - The base image remains unchanged.
  backing_store = {
    path = libvirt_volume.ubuntu_base.path

    format = {
      type = "qcow2"
    }
  }

  # The node disk itself also uses QCOW2 format.
  target = {
    format = {
      type = "qcow2"
    }
  }
}
