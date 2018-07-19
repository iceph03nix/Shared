<#
.Synopsis
Get list of licenses from directory joined computers

.DESCRIPTION
Polls Active Directory for a list of computers, compares that list to a list of already found licenses, and then checks the remaining computers for licenses using WMI

.PARAMETER Computers
Full list of Computers to be checked by script

.PARAMETER Path
Path to the folder for the CSV
#>


[Cmdletbinding()]
PARAM(
    [string[]]$Computers = (Get-ADComputer -Filter * | Select-Object -ExpandProperty Name),
    [string]$Path = 'officeinstalls.CSV'
    )


if(Test-Path $path) {$existingCSV = import-csv $path}
    

$CompletedComputers = $existingCSV | Select-Object -expandproperty PSComputerName

$UnreadComps = $Computers.where({$_ -notin $CompletedComputers})

<#$existingCSV | OGV
$CompletedComputers | OGV
$UnreadComps | OGV
#>

$Licensinginfo = Get-CimInstance softwarelicensingproduct -Filter 'Name LIKE "Office%" AND LicenseStatus != 0' -ComputerName ($UnreadComps)  -ErrorAction SilentlyContinue |
 select-object -Property Name, description, licensestatus, PSComputerName, @{n="DateFound"; E={Get-Date}}

#$alldata = $existingCSV

<#ForEach($license in $Licensinginfo) {
    $newRow = New-Object PSObject -Property @{Name = $license.Name; 
                                              Description = $license.Description; 
                                              LicenseStatus = $license.LicenseStatus;
                                              PSComputerName = $license.PSComputerName}
    $alldata += $newRow
}#>

$Licensinginfo| export-csv $Path -Append