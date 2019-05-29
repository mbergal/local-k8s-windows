$ipAddress = Get-NetIPAddress | Where { $_.InterfaceAlias.Contains("(Ethernet)") -and $_.AddressFamily -eq "IPv4" } | Select -ExpandProperty IPAddress

Write-Host "Management IP: $ipAddress"
cd c:\vagrant\win-worker
.\start.ps1 `
    -ManagementIP $ipAddress `
    -LogDir c:\k

exit

Start-Sleep -Seconds 60

c:\k\stop.ps1
cd c:\vagrant\win-worker
.\register-svc.ps1 -ManagementIP $ipAddress -LogDir c:\k

