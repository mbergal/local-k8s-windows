Start-Transcript c:\start-k8s.log

$ipAddress = Get-NetIPAddress | Sort-Object ifIndex | Where { $_.PrefixOrigin -ne "WellKnown" } | Select -First 1 | Select -ExpandProperty IPAddress

cd c:\vagrant\win-worker
.\start.ps1 `
    -ManagementIP $ipAddress `
    -LogDir c:\k

c:\k\stop.ps1

cd c:\vagrant\win-worker
.\register-svc.ps1 -ManagementIP $ipAddress -LogDir c:\k

