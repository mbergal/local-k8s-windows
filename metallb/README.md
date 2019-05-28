#

```shell
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml
```

```shell
kubectl -n metallb-system apply -f metallb-configmap.yaml 
```