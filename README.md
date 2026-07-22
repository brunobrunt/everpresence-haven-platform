# Ever Presence Haven Platform

A production-like infrastructure and application prototype for Ever Presence Haven.

## Project Components

- Terraform and KVM/libvirt virtual-machine provisioning
- Cloud-init operating-system bootstrap
- Ansible configuration management
- Highly available Kubernetes cluster
- Application deployment with Helm and GitOps
- Monitoring with Prometheus and Grafana

Kubernetes Cluster Architecture

The platform uses a highly available Kubernetes control plane consisting of three control-plane nodes and two worker nodes.

                  k8s-api.lab:6443
                    172.16.10.30
                           │
                      kube-vip
                           │
          ┌────────────────┼────────────────┐
          │                │                │
    eph-cp01         eph-cp02         eph-cp03
  172.16.10.31     172.16.10.32     172.16.10.33
    API server       API server       API server
    Controller       Controller       Controller
    Scheduler        Scheduler        Scheduler
    etcd member      etcd member      etcd member

          ┌────────────────┴────────────────┐
          │                                 │
    eph-worker01                       eph-worker02
    172.16.10.34                       172.16.10.35
Architecture Components
k8s-api.lab:6443 is the shared Kubernetes API endpoint.
172.16.10.30 is the virtual IP reserved for the Kubernetes API.
kube-vip provides control-plane endpoint availability.
eph-cp01, eph-cp02, and eph-cp03 run the API server, controller manager, scheduler, and stacked etcd.
eph-worker01 and eph-worker02 run application workloads.
A future third worker, eph-worker03, is reserved at 172.16.10.36

## Current Phase

Phase 1: Provisioning three Kubernetes control-plane nodes and two worker nodes using Terraform, KVM/libvirt and Ubuntu 24.04 cloud images.

Detailed Terraform documentation is available in:

`terraform/libvirt/README.md`

Phase 2: Using Ansible to validate and configure three Kubernetes
control-plane nodes and two worker nodes.

Terraform provisioning and cloud-init bootstrap are complete.
All five nodes have passed the Ansible preflight validation.
