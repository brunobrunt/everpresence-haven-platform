# Ever Presence Haven Platform

A production-like infrastructure and application prototype for Ever Presence Haven.

## Project Components

* Terraform and KVM/libvirt virtual-machine provisioning
* Cloud-init operating-system bootstrap
* Ansible configuration management
* Highly available Kubernetes cluster
* Application deployment with Helm and GitOps
* Monitoring with Prometheus and Grafana

## Kubernetes Cluster Architecture

The platform uses a highly available Kubernetes control plane consisting of three control-plane nodes and two worker nodes.

```text
                  k8s-api.lab:6443
                    172.16.10.30
                           |
                      kube-vip
                           |
          +----------------+----------------+
          |                |                |
      eph-cp01         eph-cp02         eph-cp03
    172.16.10.31     172.16.10.32     172.16.10.33
      API server       API server       API server
      Controller       Controller       Controller
      Scheduler        Scheduler        Scheduler
      etcd member      etcd member      etcd member
          |                |                |
          +----------------+----------------+
                           |
              +------------+------------+
              |                         |
         eph-worker01              eph-worker02
         172.16.10.34              172.16.10.35
```

### Architecture Components

* `k8s-api.lab:6443` is the shared Kubernetes API endpoint.
* `172.16.10.30` is the virtual IP reserved for the Kubernetes API.
* `kube-vip` provides availability for the shared control-plane endpoint.
* `eph-cp01`, `eph-cp02`, and `eph-cp03` run the API server, controller manager, scheduler, and stacked etcd.
* `eph-worker01` and `eph-worker02` run application workloads.
* A future third worker, `eph-worker03`, is reserved at `172.16.10.36`.

## Current Phase

### Phase 1: Terraform Infrastructure — Complete

Terraform, KVM/libvirt, cloud-init, and Ubuntu 24.04 cloud images were used to provision:

* Three control-plane nodes
* Two worker nodes
* Static IP networking
* Dedicated virtual disks
* Cloud-init bootstrap configuration

Detailed Terraform documentation is available in:

[`terraform/libvirt/README.md`](terraform/libvirt/README.md)

### Phase 2: Ansible Configuration Management — In Progress

Ansible inventory and connectivity have been configured for all five nodes.

All nodes successfully passed the preflight validation, including checks for:

* CPU, memory, and disk capacity
* Static IP configuration
* Default gateway
* Swap status
* Cloud-init completion
* QEMU guest agent
* Time synchronization
* DNS resolution

The next step is configuring the operating-system prerequisites required by Kubernetes, followed by containerd, kubeadm, kubelet, and kubectl.

Detailed Ansible documentation is available in:

[`ansible/README.md`](ansible/README.md)

## Planned Kubernetes Stack

* Kubernetes `v1.36`
* Three-node stacked-etcd control plane
* Two initial worker nodes
* `kube-vip` virtual API endpoint
* containerd runtime
* Calico networking
* Metrics Server
* Helm
* GitOps
* Prometheus and Grafana

