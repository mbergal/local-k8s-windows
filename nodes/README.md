# Installing Kubernetes locally in Hyper-V

## Creating nodes

### Required environment variables:

| Variable Name  | Value  |
|---|---|
| `VAGRANT_EXPERIMENTAL`  | `typed_triggers` |
| `VAGRANT_SMB_USERNAME` | |
| `VAGRANT_SMB_PASSWORD` | <Domain>\<Username> (e.g. `HOME\misha`)|

If `VAGRANT_EXPERIMENTAL` is correctly set you will see the following at
the start of Vagrant:

```shell
==> vagrant: You have requested to enabled the experimental flag with the following features:
==> vagrant:
==> vagrant: Features:  typed_triggers
==> vagrant:
==> vagrant: Please use with caution, as some of the features may not be fully
==> vagrant: functional yet.
```

### Clean up nodes 

```bash
vagrant destroy -f
```

### Initializing Kubernetes nodes

```bash
vagrant up  --provider=hyperv
```

If vagrant is stuck creating windows node:

* Ctrl-C
* Kill `ruby.exe`
* Re-provision node

    ```shell
    vagrant up  --provider=hyperv--provision win-worker-1
    ```

    Reprovisioning will reapply all provisioning steps for VM (node).
    All provisioning steps are idempotent. 


## Install networking using Flannel Gateway-Host mode

Flannel is installed in Gateway-Host mode:

`networking\kube-flannel.yml`:

```yaml
  net-conf.json: |
    {
      "Network": "10.244.0.0/16",
      "Backend": {
        "Type": "host-gw"
      }
    }
```

Flannel daemon sets will be patched to run on Linux only by 
`nodes\master\node-selector-patch.yaml`:

```yaml
spec:
  template:
    spec:
      nodeSelector:
        beta.kubernetes.io/os: linux
```

### Installation Results


* Virtual Machines

| Vagrant name  | VM name        | User    | Password |
|---------------|----------------|---------|---------|
| `master`      | `k8s-master`   | vagrant | vagrant |
| `worker-1`    | `k8s-worker-1` | vagrant | vagrant |
| `win-worker-1`| `k8s-win-worker-1` | Vagrant | vagrant |

* Cluster config file `config`
* Cluster join instructions `kubeadm-join`
* Cluster join script `kubeadm-join.sh`

## Testing

### Do Linux pods work?

Create Linux pod:

```bash
$env:KUBECONFIG="..."
kubectl apply -f 
```

Check that it is running:

```bash
kubectl get pods
```

### Do Windows pods work?

Create Windows pod:

```bash
$env:KUBECONFIG="..."
kubectl apply -f 
```


### Can Linux pods communicate with outside


```bash
kubectl get pods

```

### Can Linux pods communicate with Windows pods

### Can Windows pods communicate with outside

### Can Windows pods communicate with Linux pods

