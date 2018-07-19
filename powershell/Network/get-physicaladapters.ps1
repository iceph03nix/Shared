<#
.SYNOPSIS
A script for getting Physical adapters per Chapter 22 Lab of Learn Powershell Lunches

.EXAMPLE
Get-PhysicalAdapters -computername localhost
#>
[cmdletBinding()]
Param (
    [parameter(Mandatory)]
    [alias('hostname')]
    $ComputerName = 'localhost'
)
Write-Verbose "Now Executing get-physicaladapters on $computername"
Get-WmiObject win32_networkadapter -ComputerName $computername |
    where { $_.physicalAdapter } |
    select MACAddress, AdapterType, DeviceID, Name, Speed
Write-Verbose "Command Complete"