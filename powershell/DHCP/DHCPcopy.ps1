$oldserver = 
$newserver = 


#get old reservations
$oldreservations = Get-DhcpServerv4Reservation -ComputerName $oldserver -ScopeId 192.168.2.0

#add to new server
$oldreservations | Add-DhcpServerv4Reservation -ComputerName $newserver