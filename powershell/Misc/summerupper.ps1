$numbers = 90000, 1000, 2000, 3000, 4000
[int]$sum = 0
[int]$limit = 95000
foreach($number in $numbers) {
    if ($sum + $number -lt $limit) {
        $sum = $sum + $number
        $lastnumber = $number
       }
    else {
        $lastnumber
        Break
        }
    }