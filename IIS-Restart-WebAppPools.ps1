$EMS = Get-ADComputer -filter {name -like "usav*-emsevt-*"}
foreach ($computer in $EMS){
    $testConnection = Test-Connection $computer.name -Count 1
    }
    IF ($testConnection = "True"){
     Invoke-Command -ComputerName $_.name -ScriptBlock {Restart-WebAppPool *}
        }
 