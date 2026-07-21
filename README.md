# Ever Presence Haven Platform

A production-like infrastructure and application prototype for Ever Presence Haven.

## Project Components

- Terraform and KVM/libvirt virtual-machine provisioning
- Cloud-init operating-system bootstrap
- Ansible configuration management
- Highly available Kubernetes cluster
- Application deployment with Helm and GitOps
- Monitoring with Prometheus and Grafana

## Current Phase

Phase 1: Provisioning three Kubernetes control-plane nodes and two worker nodes using Terraform, KVM/libvirt and Ubuntu 24.04 cloud images.

Detailed Terraform documentation is available in:

`terraform/libvirt/README.md`
