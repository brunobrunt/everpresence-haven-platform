
# A Terraform provider is a plugin that allows Terraform to communicate
# with and manage resources on another platform.
#
# In this project, the libvirt provider translates Terraform configuration
# into libvirt operations such as creating:
# - KVM virtual machines
# - QCOW2 storage volumes
# - Storage pools
# - Cloud-init disks
# - Virtual network interfaces
#
# Without this provider, Terraform does not know how to manage KVM/libvirt.

provider "libvirt" {
  # The URI tells the provider which libvirt environment to connect to.
  #
  # qemu:///system connects to the system-wide libvirt daemon.
  # This gives Terraform access to the same VMs, networks, and storage pools
  # displayed by:
  #
  # virsh -c qemu:///system list --all
  #
  # We reference a variable instead of hardcoding the value here.
  uri = var.libvirt_uri
}
