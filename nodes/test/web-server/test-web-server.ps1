$ErrorActionPreference = "Stop"

$env:KUBECONFIG = Resolve-Path "..\..\config"

Write-Host "Creating first Linux web server - apple"
kubectl apply -f apple.yaml 
Write-Host "...done"

Write-Host "Creating second Linux web server - banana"
kubectl apply -f banana.yaml
Write-Host "...done"

Write-Host "Creating Windows web server - watermelon"
kubectl apply -f watermelon.yaml
Write-Host "...done"

Write-Host "Creating ingress"
kubectl apply -f ingress.yaml

function WaitForPodToStart([string] $podName) {
    Write-Host "Waiting for $podName to start..."
    while ($true) {
        $status = GetPodStatus($podName)
        if ($status -eq "Running") {
            break;
        }
        else {
            Start-Sleep -Seconds 1
        }
    }    
    Write-Host "Pod $podName has started"
}

function GetPodStatus([string] $podName) {
    return (kubectl get pod hello-world-linux -o json | ConvertFrom-Json | Select -ExpandProperty Status | Select -ExpandProperty phase).Trim()
}

WaitForPodToStart "apple-app"
WaitForPodToStart "banana-app"
WaitForPodToStart "watermelon-app"

kubectl exec -it hello-world-linux --  apt-get update
kubectl exec -it hello-world-linux --  apt-get install -y wget

Write-Host "Testing apple-service..."
kubectl exec -it hello-world-linux -- wget -qO - apple-service:5678
Write-Host "Testing banana-service..."
kubectl exec -it hello-world-linux -- wget -qO - banana-service:5678
Write-Host "Testing watermelon-service..."
kubectl exec -it hello-world-linux -- wget -qO - watermelon-service:80
