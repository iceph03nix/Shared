Function get-oldADComputers {

<#
.SYNOPSIS
Get a List of all Computers that have not signed into Active Directory within the specified time

.DESCRIPTION
Retrieves a collection of Computers from Active Directory comparing LastLogonDate against the age specified.  Leaves out disabled computers by default but can be set otherwise

.PARAMETER Age
The minimum number of days a computer hasn't logged in.  Default is 120

.PARAMETER IncludeDisabled
Specifies whether the Command shoudl return Disabled Accounts

#>

[CmdletBinding()]

Param (
    [int]$Age = 120,
    [switch]$IncludeDisabled
)

$cutoff = (get-date).AddDays(-($age))

If ($IncludeDisabled) {
    $Computers = Get-ADComputer -Filter {(LastLogonDate -lt $cutoff)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate |
                         Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated
    }
Else {
    $Computers = Get-ADComputer -Filter {(LastLogonDate -lt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate |
                         Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated
    }

$Computers | Sort-Object -Property LastLogonDate | Out-Default
}

Function get-oldADUsers {

<#
.SYNOPSIS
Get a List of all Users that have not signed into Active Directory within the specified time

.DESCRIPTION
Retrieves a collection of Users from Active Directory comparing LastLogonDate against the age specified.  Leaves out disabled Users by default but can be set otherwise

.PARAMETER Age
The minimum number of days a User hasn't logged in.  Default is 120

.PARAMETER IncludeDisabled
Specifies whether the Command should return Disabled Accounts

#>

[CmdletBinding()]

Param (
    [int]$Age = 120,
    [switch]$IncludeDisabled
)

$cutoff = (get-date).AddDays(-($age))

If ($IncludeDisabled) {
    $User = Get-ADUser -Filter {(LastLogonDate -lt $cutoff)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate |
                         Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated
    }
Else {
    $User = Get-ADUser -Filter {(LastLogonDate -lt $cutoff) -and (Enabled -eq $True)} -Properties DisplayName, OperatingSystem, DistinguishedName, whenCreated, Enabled, LastLogonDate |
                         Select-Object -Property DisplayName, DistinguishedName, Enabled, LastLogonDate, whenCreated
    }

$User | Sort-Object -Property LastLogonDate
}

Function Clean-ADUsers {
<#
.SYNOPSIS
Move Disabled User Accounts to the Disabled User OU


#>

[CmdletBinding()]
PARAM (

    )

Get-ADUser -Filter {Enabled -eq "False"} -Properties DistinguishedName | 
    ? {$_.DistinguishedName -notlike "*OU=Disabled Users*"} |
    Move-ADObject -TargetPath "OU=Disabled Users,DC=cattle-empire,DC=net" -Confirm
}