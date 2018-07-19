#Load DLL's
[reflection.assembly]::LoadFile("$PSScriptRoot\DYMO.DLS.Runtime.dll")
[reflection.assembly]::LoadFile("$PSScriptRoot\DYMO.Label.Framework.dll")
[reflection.assembly]::LoadFile("$PSScriptRoot\DYMO.Common.dll")

#Load Template in $label
$label = [DYMO.Label.Framework.Label]::Open("$PSScriptRoot\Wiped.label")

#Change objectvalues on $label
$label.SetObjectText("UserName","John Doe")

#Print $label
$label.print("Dymo LabelWriter 450")