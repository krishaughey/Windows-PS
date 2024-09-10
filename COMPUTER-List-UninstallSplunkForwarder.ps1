 #Uninstall Splunk Universal Forwarder
## Stop Splunk Services and Uninstall the SplunkForwarder Application from a List of Servers
#### https://github.com/krishaughey

### Get a list of servers to run against
$ServerList = Get-Content C:\Temp\ServerList.txt
foreach ($ServerObject in $ServerList){
    ### Open a session to work within
    $s = New-PSSession -ComputerName $ServerObject

    ### Stop and Delete Service
    Invoke-Command -Session $s -ScriptBlock {Stop-Service SplunkForwarder}
    Invoke-Command -Session $s -ScriptBlock {sc.exe delete SplunkForwarder}

    ### and then Uninstall Application
    Invoke-Command -Session $s -ScriptBlock {$Splunk = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "UniversalForwarder"}}
    Invoke-Command -Session $s -ScriptBlock {$Splunk.Uninstall()}
    Remove-PSSession -Session $s
}