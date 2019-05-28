$env:KUBECONFIG = Resolve-Path "..\..\config"

kubectl apply -f hello-world-linux.yaml 
kubectl apply -f hello-world-win.yaml 


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
    return (kubectl get pod $podName -o json | ConvertFrom-Json | Select -ExpandProperty Status | Select -ExpandProperty phase).Trim()
}


WaitForPodToStart "hello-world-linux"
WaitForPodToStart "hello-world-win"

kubectl exec -it hello-world-linux echo "hello-world-linux is OK"
kubectl exec -it hello-world-win cmd /c echo "hello-world-win is OK"