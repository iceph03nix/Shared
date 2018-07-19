$Path = '0101_Session102.txt'
$OGContent = Get-Content -Path $Path

$HEXEIDs = ($OGContent).split(' ') | Select-String -pattern '8000D' | foreach-object {$_.ToString()}

#$HEXEIDs | ForEach-Object {[Convert]::ToInt34("0x$_",16)}
$HEXEIDs.replace('8000','') | ForEach-Object {[Convert]::ToInt32("0x$_",16)}
#| ForEach-Object {[Convert]::ToInt32("0x$_",16)}
#$HEXEIDs.ToString() | ForEach-Object {"0x$_"}