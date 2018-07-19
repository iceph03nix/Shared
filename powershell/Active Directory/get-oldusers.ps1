<#
.SYNOPSIS
Get sets of all Users in Active Directory based on usage

.DESCRIPTION
Collects all Active Directory Users and sorts them by wheather they are enabled and by the time since they last logged into the Domain.  Results are output to a CSV file defined by the PATH function as well as OGV.  Age since last logon can be adjusted via the Age parameter.

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

$Users = Get-ADUser -Filter {(LastLogonDate -gt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated

$oldUsers = Get-ADUser -Filter {(LastLogonDate -lt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated

$disabledUsers = Get-ADUser -Filter {(Enabled -eq $False)} -Properties DisplayName, DistinguishedName, whenCreated, Enabled, LastLogonDate | Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated


if ($showOGV) {
    $disabledUsers | ogv
    $Users | ogv
    $oldUsers | ogv
}


#show counts

$totalactive = $Users.count
$totaldisabled = $disabledUsers.count
$totalold = $oldUsers.count

"Total Active Users: $totalactive, Total Inactive Users: $totalold, Total Disabled Users: $totaldisabled" | out-host

#save report to file

$Users | Export-Csv -Path "$path\ActiveUsers.csv"

$oldUsers | Export-Csv -Path "$path\InactiveUsers.csv"

$disabledUsers | Export-Csv -Path "$path\DisabledUsers.csv"