param([switch] $Force);


$ErrorActionPreference = "Stop"

Write-Host ($PSVersionTable|Out-String)

if ((Test-Path -Path C:\install-k8s.done) -and -not $Force) {
    Write-Host "This has already been done"
    exit 0;
}


Write-Host "Starting Docker ..."
Start-Service Docker
Write-Host "...done"

Write-Host "Making microsoft/nanoserver:latest..."
docker pull mcr.microsoft.com/windows/nanoserver:1809
docker tag mcr.microsoft.com/windows/nanoserver:1809 microsoft/nanoserver:latest
Write-Host "...done"

ls c:\vagrant
if ( !(Test-Path c:\k)) {
    mkdir c:\k
}

Write-Host "Setting environment variables..."
$env:Path += ";C:\k"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\k", [EnvironmentVariableTarget]::Machine)

$env:KUBECONFIG = "C:\k\config"
[Environment]::SetEnvironmentVariable("KUBECONFIG", "C:\k\config", [EnvironmentVariableTarget]::User)

Write-Host "...done"

Write-Host "Copying kubernetes executables..."
cp C:\vagrant\win-worker\bin\*.exe C:\k\
cp C:\vagrant\config C:\k\
Write-Host "...done"

# kubectl config view

Write-Host "Getting start.ps1 ..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
wget https://raw.githubusercontent.com/Microsoft/SDN/master/Kubernetes/flannel/start.ps1 -o start.ps1
Write-Host "...done"

Write-Host "Setting up flexvolume SMB plugin for k8s..."
cp -R c:\vagrant\win-worker\microsoft.com~smb.cmd c:\usr\libexec\kubernetes\kubelet-plugins\volume\exec\microsoft.com~smb.cmd -Force -Container
Write-Host "...done"

certutil -enterprise -f -v -AddStore "Root" C:\vagrant\registry.local.crt

echo "" > C:\install-k8s.done
