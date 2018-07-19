$Servers = 'vcenter', 'vcenter-ce'

function get-releventsnapshots ($servername) {
    "checking $Servername"
    get-vm -Server $servername | Get-Snapshot | Select-Object -Property Created, VM, VMId, SizeGB, Name 
    
}

function connect-server ($Servername) {
    $creds = Get-VICredentialStoreItem -Host $servername

    $user = $creds.User
    $pass = $creds.Password

    Connect-VIServer -Server $Servername -User $user -Password $pass

}

function send-results ($results) {
    $SnapshotString = $results | Out-String
    Write-Host $SnapshotString
    if ($SnapshotString -ne $null) {
        Send-MailMessage -To "ksexson@cattle-empire.net" -From "VMWare Snapshots <it@cattle-empire.net>" -SmtpServer "mail.cattle-empire.net" -Body $SnapshotString -Subject "VMWare Snapshot report"
    }
}


$snapshots = foreach($server in $Servers) {
    $connectreport = connect-server -Servername $server
    get-releventsnapshots -servername $server
} 

send-results -results $snapshots