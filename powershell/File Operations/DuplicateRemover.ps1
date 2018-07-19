#Duplicate Finder

#finds duplicat files with standard windows (d).ext and moves them to a 'Duplicate' folder in the root of the search

$folderPath = 

New-Item -Path $folderPath -ItemType Directory -Name 'Duplicates'

$duplicateFolderPath = Join-Path -Path $folderPath -ChildPath 'Duplicates'

Get-ChildItem -Path $folderPath -Exclude $duplicateFolderPath -Recurse | Where-Object { $_.name -match '\(\d\).\w' } | Move-Item -Destination $duplicateFolderPath -Force