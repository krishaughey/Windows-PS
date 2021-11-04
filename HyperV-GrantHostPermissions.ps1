$Rule1 = $VH11+':(OI)(CI)(GR,WD,AD)'
$Rule2 = $VH12+':(OI)(CI)(GR,WD,AD)'
$Rule3 = $VH13+':(OI)(CI)(GR,WD,AD)'

$VH11 = "card\VH11$"
$VH12 = "card\VH12$"
$VH13 = "card\VH13$"

$Volumes = Get-ChildItem "C:\ClusterStorage\" | Select-Object FullName
Foreach($Volume in $Volumes){
    $FullName = $Volume.FullName
    & icacls "$FullName\*" /grant $Rule1
    & icacls "$FullName\*" /grant $Rule2
    & icacls "$FullName\*" /grant $Rule3
}
