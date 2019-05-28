param([switch] $Force);

$ErrorActionPreferenece = "Stop"

if ((Test-Path -Path C:\install-docker.done) -and -not $Force) {
    Write-Host "This has already been done"
    exit 0;
}

ls c:/vagrant
Write-Host "Installing Nuget..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Write-Host "Installing DockerMsftProvider..."
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Write-Host "Installing Docker..."
Install-Package -Name Docker -ProviderName DockerMsftProvider -Force
#Restart-Computer -Force
echo "" > C:\install-docker.done
