function Get-SystemInfo {

<#
.SYNOPSIS
Retrieves key system version and model information from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Insturmentation to retrieve information from one or more computers.  Specify Computers by name or IP address
.PARAMETER ComputerName
One or More computer names or IP addresses, up to 10.
.PARAMETER LogErrors
Specify this Switch to create a text log file of computers that could not be queried.
.PARAMETER ErrorLog 
When used with -LogErrors, specifies the file path and name for the text log of failed computers. Defaults to C:\Retry.txt
.EXAMPLE
 Get-content names.txt | get-systeminfo
.EXAMPLE
 Get-systeminfo -ComputerName Localhost, Server01
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer Name or IP address")]
        [Alias('Hostname')]
        #[ValidateCount(1,10)]
        [string[]]$ComputerName,

        [string]$ErrorLog = 'c:\retry.txt',

        [Switch]$LogErrors
    )
    BEGIN{
        Write-Verbose "Error Log will be $ErrorLog"
    }
    PROCESS{
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Querying $Computer"
            $0S = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
            Write-Verbose "Win32_OperatingSystem"
            $Comp = Get-WmiObject -Class Win32_computerSystem -ComputerName $Computer
            Write-Verbose "Win32_ComputerSystem"
            $BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName $Computer
            Write-Verbose "Win32_BIOS"
            $IP = Get-WmiObject -Class win32_NetworkAdapterConfiguration -ComputerName $Computer | Where-Object {$_.IPAddress -like '192.*'} | Select-Object -First 1
            $adminStatus = Switch ($Comp.AdminPasswordStatus) {
                                1 {"Disabled"}
                                2 {"Enabled"}
                                3 {"NA"}
                                4 {"Unkown"}
                           }
            
            $Props = @{'ComputerName'=$Computer;
                       'PCName'=$Comp.Name
                       'Workgroup'=$Comp.workgroup;
                       'OSVersion'=$OS.version;
                       'SPVersion'=$OS.ServicePackMajorVersion;
                       'BIOSSerial'=$BIOS.serialnumber;
                       'Manufacturer'=$Comp.manufacturer;
                       'AdminPassword'=$adminStatus;
                       'Model'=$Comp.model}
            Write-Verbose "WMI Queries Complete"
            $obj = New-Object -TypeName PSObject -Property $Props
            Write-Output $obj
        }
    }
    END{
        Write-Verbose "Ending Get-SystemInfo"
        }
    }

#Get-SystemInfo -ComputerName Localhost, Ksexson-pc, ehirsh-pc

Function Get-VolumeInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True,
                   HelpMessage="Computer Name or IP Address")]
        [Alias("HostName")]
        [string[]]$ComputerName,
        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN{
        Write-Verbose "Starting Get-VolumeInfo"
    }
    PROCESS{
        ForEach ($Computer in $ComputerName) {
            Write-Verbose "Getting Volume Info from $Computer"
            $Volumes = Get-WmiObject -class win32_volume -ComputerName $Computer
            foreach ($Volume in $Volumes) {
                Write-Verbose "Processing Volume $Volume"
                $Props = @{'FreeSpace(GB)'=([Math]::Round($Volume.FreeSpace/1GB,2));
                           'Drive'=$Volume.Name;
                           'ComputerName'=$Computer;
                           'PCName'=$Volume.SystemName;
                           'Capacity(GB)'=([Math]::Round($Volume.Capacity/1GB,2));
                           }

                $obj = New-Object -TypeName PSObject -Property $Props
                Write-Output $obj
                }
        }
    }
    END{
        Write-Verbose "Ending Get-VolumeInfo"
        }
    }

#Get-VolumeInfo -ComputerName localhost, ksexson-pc, ehirsh-pc

Function Get-ServiceInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)][string[]]$ComputerName,
        [string]$ErrorLog = 'C:\Retry.txt'
    )
    BEGIN{
        
    }
    PROCESS{
        ForEach ($Computer in $ComputerName) {
            $Services = Get-WmiObject -class win32_Service -ComputerName $Computer
            foreach ($Service in $Services) {
                $processid = $Service.ProcessID
                $Process = Get-WmiObject -Class win32_process -ComputerName $Computer | ? {$_.ProcessID -eq $Processid}

                $Props = @{'ComputerName'=$Computer;
                           'PCName'=$Process.CSName;
                           'ThreadCount'=$Process.threadcount;
                           'ProcessName'=$Process.ProcessName;
                           'Name'=$Process.Name;
                           'PID'=$processid;
                           'PeakPageFile'=$Process.peakpagefileusage;
                           'VMSize'=$Process.VirtualSize;
                           }

                $obj = New-Object -TypeName PSObject -Property $Props
                Write-Output $obj
                }
        }
    }
    END{}
    }

#Get-ServiceInfo -ComputerName localhost, ksexson-pc, ehirsh-pc