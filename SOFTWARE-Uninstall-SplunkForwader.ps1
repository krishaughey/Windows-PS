#Uninstall SplunkForwarder
## Stop Splunk services and uninstall the SplunkForwarder application
#### https://github.com/krishaughey

### Check for Splunk Service and Process
$ServiceCheck = Get-Service SplunkForwarder
if ($Null -ne $ServiceCheck) {

    ### Stop and Delete Service
    Stop-Service SplunkForwarder
    sc.exe delete SplunkForwarder

    ### Uninstall Application
    $Splunk = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "UniversalForwarder"}
    $Splunk.Uninstall()
}
else {
    Write-Output "Splunk Service Not Installed"
}