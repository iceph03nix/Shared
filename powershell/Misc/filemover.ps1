$user = 'ksexson'
$src = "C:\users\$user\Desktop\Test"
$target = "C:\users\$user\Desktop\New"
set-location $src

$files = gci -file -Recurse 

foreach ($file in $files) {
    if (test-path $Target -PathType leaf) {
        $file.BaseName 
    }
    Move-item -Path $file -Destination $target
}