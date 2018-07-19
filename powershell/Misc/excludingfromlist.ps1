<#$longlist = 'a', 'b', 'c', 'd', 'e', 'f'
$shortlist = 'b', 'e', 'f'

$longlist.Where({$_ -notin $shortlist})#>

$Services1 = get-service Win* | Select-Object -Property Name, Status, DisplayName

$services2 = get-service xb* | Select-Object -Property Name, Status, DisplayName

$Services1 | Export-Csv -path csvtest.csv

#$Services1
#$Services2

$CSVServices = Import-Csv -Path csvtest.csv

#$AllMSServices = $CSVServices + $Services2


ForEach($Service in $services2) {
    $newRow = New-Object PSObject -Property @{Name = $Service.Name; DisplayName = $Service.DisplayName; Status = $Service.Status}
    $CSVServices += $newRow 
}

$CSVServices
#$AllMSServices