[CmdletBinding()]
$FailedToConnect = @()
function get-computerlist {
    Get-ADComputer -Filter * | Where-Object {$_.enabled -eq $True} | Select-Object -ExpandProperty Name
}

function get-incompletecomputers ($path) {
    import-csv -Path $path | Where-Object {$_.BIOSSerial -eq ''} | select-object -ExpandProperty ComputerName
}

function get-biosinfo ($ComputerName) {
    Try {Get-CimInstance -ClassName win32_bios -ComputerName $ComputerName -ErrorAction Stop}
    Catch {Get-WmiObject -ClassName win32_bios -ComputerName $ComputerName -ErrorAction SilentlyContinue}
}

function get-ipinfo ($ComputerName) {
    Try {Get-CimInstance -ClassName Win32_NetworkAdapterconfiguration -ComputerName $ComputerName -ErrorAction Stop | Where-Object {$_.IPAddress -like '192.*'} | Select-Object -Property IPAddress, pscomputername}
    Catch {Get-WmiObject -ClassName Win32_NetworkAdapterconfiguration -ComputerName $ComputerName -ErrorAction SilentlyContinue | Where-Object {$_.IPAddress -like '192.*'} | Select-Object -Property IPAddress, pscomputername}
}

function get-computersystem ($ComputerName) {
    Try {Get-CimInstance -computername $ComputerName -ClassName Win32_ComputerSystem -ErrorAction stop}
    Catch {Get-WmiObject -computername $ComputerName -ClassName Win32_ComputerSystem -ErrorAction SilentlyContinue}
}

function get-computerinfo ($computers) {
    foreach($computer in $Computers) {
        $BIOS = get-biosinfo -ComputerName $computer
        $IP = get-ipinfo -ComputerName $computer
        $COMP = get-computersystem -ComputerName $Computer

        $Info = @{
            'ComputerName' = $computer;
            'BIOSSerial' = $BIOS.serialnumber;
            'Manufacturer'= $COMP.manufacturer;
            'Model'= $Comp.model;
            'IP' = ($IP.IPAddress | Where-Object {$_ -like '192.*'})
        }
        $obj = New-Object -TypeName PSObject -Property $Info
        Write-Output $obj
    }
}

Function get-dellcomputers ($path) {
    $CSVData = import-csv -path $path
    $CSVData | where-object {$_.manufacturer -like '*dell*'}
}