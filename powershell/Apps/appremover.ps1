# First:
# Create a Template by removing the apps on a machine until it's in the desired state
# Get-AppxPackage -AllUsers *$appnamehere* | Remove-AppxPackage -verbose
#
# Note: Staged apps cannot be removed
#
# Next: 
# Create a Whitelist using the following command.  You may need to edit the path depending on where you have permissions
#
# Get-AppxPackage -AllUsers | Where-Object {$_.PackageUserInformation -notlike "*staged*"} | Export-Csv -Path "c:\scripts\appxwhitelist.csv" -Force


# get all installed apps
$installedapps = Get-AppxPackage -AllUsers | Where-Object {$_.PackageUserInformation -notlike "*staged*"} 

# import the whitelist  EDIT THIS PATH TO LINK TO YOUR EXPORTED WHITELIST
$whitelist = Import-Csv -Path C:\scripts\appxwhitelist.csv

#
$installedapps | ForEach-Object {
    $currentapp = $_.Name
    if ($whitelist.PackageFullName -contains $_.PackageFullName){
    
    }
    else {
    $currentapp | Out-Host 
    }
}