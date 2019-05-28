$ipAddress = Get-NetIPAddress | Sort-Object ifIndex | Where { $_.PrefixOrigin -ne "WellKnown" } | Select -First 1 |Select -ExpandProperty IPAddress

.\start.ps1 `
    -ManagementIP $ipAddress `
    -LogDir c:\k

