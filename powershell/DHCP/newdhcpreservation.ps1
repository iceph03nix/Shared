Param (
$MAC,
$IP,
$DHCPServer = 'adfs-01',
$scopeID = 192.168.2.0
)
#get existing lease info
$existinglease = Get-DhcpServerv4Lease -ComputerName $DHCPServer -IPAddress $IP 

#set the reservation
Add-DhcpServerv4Reservation -ComputerName $DHCPServer -ScopeId $scopeID -IPAddress $IP -ClientId $MAC

#remove existing lease if it exists
if ($existinglease) {
Remove-DhcpServerv4Lease -ComputerName $DHCPServer -IPAddress $IP
Invoke-Command -ComputerName $Existinglease -scriptblock {ipconfig /release}
}

#reset variable to Null
$existinglease = $Null