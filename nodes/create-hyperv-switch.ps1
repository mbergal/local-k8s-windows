$ErrorActionPreference = "Stop"

$switchName = "k8s"
$existingVMSwitch = Get-VMSwitch $switchName | ? { $_.Name -eq "k8s" }
if ( $existingVMSwitch -ne $null ) {
    Remove-VMSwitch $switchName -Force
}
$newSwitch = New-VMSwitch –SwitchName $switchName –SwitchType Internal –Verbose
$ifIndex = Get-NetAdapter | ? { $_.Name.Contains("(k8s)") } | Select-Object -ExpandProperty ifIndex
Write-Host $ifIndex

New-NetIPAddress –IPAddress 192.168.200.1 -PrefixLength 24 -InterfaceIndex $ifIndex –Verbose
New-NetNat –Name k8s –InternalIPInterfaceAddressPrefix 192.168.200.0/24 –Verbose

# Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter –SwitchName $switchName
