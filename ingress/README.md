# Install nginx-ingress

```shell
kubectl create -f ingress-nginx.namespace.yaml
kubectl apply -f metallb.yaml
```

## Run tests

```powershell
.\test-ingress.ps1 
```

