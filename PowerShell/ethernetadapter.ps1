$ipaddr = "10.0.0.4"
$prefix = 16
$gateway = "10.0.0.1"

$interface_list = New-Object System.Collections.Generic.List[System.Int32]

Get-NetAdapter | Tee-Object -Variable netadapter

$netadapter | % { $interface_list.Add($_.ifIndex) }

$ifIndex = Read-Host "`nEnter the Interface Index number you want to modify"

while ($interface_list -notcontains $ifIndex) {
    Write-Host "That was not a valid Interface Index!" -ForegroundColor Red
    $ifIndex = Read-Host "Enter a valid Interface Index" 
}

$ifconfig = Get-NetIPInterface -ifIndex $ifIndex -AddressFamily IPv4

if ($ifconfig.DHCP -eq "Enabled") {
    Set-NetIPInterface -ifIndex $ifIndex -DHCP Disabled
}

Set-NetIPAddress -InterfaceIndex $ifIndex -IPAddress $ipaddr -PrefixLength $prefix -DefaultGateway $gateway

Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddress 127.0.0.1