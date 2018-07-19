
#get all disabled users
$disabledusers = Get-ADUser -Filter {Enabled -eq "False"} -Properties *

#filter out users already in the Disabled Users Group
$newdisabledusers = $disabledusers | ? {$_.DistinguishedName -notlike "*OU=Disabled Users*"}

#move users to the disabled users group with a confirmation
$newdisabledusers | Move-ADObject -TargetPath "OU=Disabled Users,DC=cattle-empire,DC=net" -Confirm