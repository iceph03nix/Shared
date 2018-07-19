#get all disabled users
$disabledcomputers = Get-ADcomputer -Filter {Enabled -eq "False"}

#filter out users already in the Disabled Users Group
$newdisabledcomputers = $disabledcomputers | ? {$_.DistinguishedName -notlike "*OU=Disabled Computers*"}

#move users to the disabled users group with a confirmation
$newdisabledcomputers | Move-ADObject -TargetPath "OU=Disabled Computers,DC=cattle-empire,DC=net" -Confirm