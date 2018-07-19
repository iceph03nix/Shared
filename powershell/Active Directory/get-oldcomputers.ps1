<#
.SYNOPSIS
Get sets of all Computers in Active Directory based on usage

.DESCRIPTION
Collects all Active Directory Computers and sorts them by wheather they are enabled and by the time since they last logged into the Domain.  Results are output to a CSV file defined by the PATH function as well as OGV.  Age since last logon can be adjusted via the Age parameter.

.PARAMETER path
The path to the directory where the results will be placed.

.PARAMETER age
The minimum number of days a computer hasn't logged in.  Default is 120

.PARAMETER showOGV
Output to Grid View as well as CSV
#>

Param (
    [string]$path = (Split-Path -parent $PSCommandPath),
    [int]$age = 120,
    [switch]$showOGV
)


$cutoff = (get-date).AddDays(-($age)) #select a date in the past as a cutoff date

#generate lists

$Computers = Get-ADComputer -Filter {(LastLogonDate -gt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated

$oldComputers = Get-ADComputer -Filter {(LastLogonDate -lt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated

$disabledComputers = Get-ADComputer -Filter {(Enabled -eq $False)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated


if ($showOGV) {
    $disabledComputers | out-gridview
    $Computers | out-gridview
    $oldComputers | out-gridview
}


#show counts

$totalactive = $Computers.count
$totaldisabled = $disabledComputers.count
$totalold = $oldComputers.count

"Total Active Computers: $totalactive, Total Inactive Computers: $totalold, Total Disabled Computers: $totaldisabled" | out-host

#save report to file

$Computers | Export-Csv -Path "$path\ActiveComputers.csv"

$oldComputers | Export-Csv -Path "$path\InactiveComputers.csv"

$disabledComputers | Export-Csv -Path "$path\DisabledComputers.csv"