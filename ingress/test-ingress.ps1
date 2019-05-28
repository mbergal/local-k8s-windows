kubectl exec -it hello-world-linux -- apt-get update
kubectl exec -it hello-world-linux -- apt-get install -y wget curl

kubectl exec -it hello-world-linux -- wget -qO- 10.101.60.76/apple --no-check-certificate
kubectl exec -it hello-world-linux -- wget -qO- 10.101.60.76/banana --no-check-certificate

