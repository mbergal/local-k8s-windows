# Creating Kubernetes mixed nodes cluster with Vagrant and Hyper-V.

This repo describes the process of creating Kubernetes 1.14 cluster
with mixed Linux/Windows worker nodes on Windows.

* Create nodes using Vagrant. See [nodes](./nodes/README.md).
* Setup ingress-nginx. See [ingress](./ingress/README.md).
* Setup MetalLB. See [ingress](./metallb/README.md).

If you need to expose Load Balancer outside local machine:

```shell
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=192.168.144.254
netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=443 connectaddress=192.168.144.254
```

Where `192.168.144.254` is a load balancer address from [MetalLB config map](./metallb/metallb-configmap.yaml).
