$computername = Get-ADComputer -Filter * 

$UptimeData = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $computername.name -ErrorAction SilentlyContinue | 
    Select-Object -Property PSComputername, caption, lastbootuptime, @{Name="DaysRunning"; Expression={ (((get-date)-($_.lastbootuptime)).days) } }, installdate, osarchitecture, status |
    ? {$_.DaysRunning -gt 10} |
    Sort-Object DaysRunning -Descending

$UptimeDataString = $UptimeData | Out-String

if ($UptimeDataString -ne $null) {
    Send-MailMessage -To "ksexson@cattle-empire.net" -From "Uptime Data <it@cattle-empire.net>" -SmtpServer "mail.cattle-empire.net" -Body $UptimeDataString -Subject "Uptime Report"
}