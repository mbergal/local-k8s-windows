$ErrorActionPreference = "Stop"

Write-Host "Disabling firewall ..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "... done"