$env:KUBECONFIG = Resolve-Path "..\..\nodes\config"

Write-Host "Creating first Linux web server - apple"
kubectl apply -f apple.yaml 
Write-Host "...done"

Write-Host "Creating second Linux web server - banana"
kubectl apply -f banana.yaml
Write-Host "...done"

Write-Host "Creating ingress"
kubectl apply -f ingress.yaml

function WaitForPodToStart([string] $podName) {
    Write-Host "Waiting for $podName to start..."
    while ($true) {
        $status = GetPodStatus("hello-world")
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

Write-Host "Testing apple-service..."
kubectl exec -it hello-world-linux -- wget -qO - apple-service:5678
Write-Host "Testing banana-service..."
kubectl exec -it hello-world-linux -- wget -qO - banana-service:5678
