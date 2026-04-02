$serverList = Get-ADComputer -filter {name -like "<SERVER>"}
foreach ($computer in $serverList){
    $testConnection = Test-Connection $computer.name -Count 1
    }
    IF ($testConnection = "True"){
     Invoke-Command -ComputerName $_.name -ScriptBlock {Restart-WebAppPool *}
        }
 