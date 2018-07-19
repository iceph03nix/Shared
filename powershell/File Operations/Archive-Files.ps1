[CmdletBinding()]
Param(
[string]$ArchivePath = 'C:\archive',
[string]$OriginalPath = 'C:\Originals',
[int]$AgeYears = 5
)


$oldFileDate = (Get-Date).AddYears(-($AgeYears))

Write-Information "Preparing to remove all files not accessed before $oldFileDate"

Get-ChildItem -Path $OriginalPath -Recurse -file | ForEach-Object {
    if($_.LastAccessTime -le $oldFileDate) {
        #$_.FullName | GM        
        $newfilepath = ($_.DirectoryName).Replace($OriginalPath,$ArchivePath)
        $oldpath = $_.FullName
        #$newfilepath
       
        
        #while the original file directory doesn't exist...
        
        if (!(Test-Path -Path $newfilepath)) {
            New-Item -Path $newfilepath -ItemType Directory -Force
            }


        Write-Verbose "Moving $oldpath to $newfilepath"
        $lastaccess = $_.LastAccessTime
        Write-Verbose "Last Access was at $lastaccess"
        
            
        Move-Item -Path $_.FullName -Destination $newfilepath -Force 
        }


}
