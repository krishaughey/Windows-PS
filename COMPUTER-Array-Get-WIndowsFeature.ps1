# List of required Windows Features
$features = @(
    "RSAT-RemoteAccess",
    "Web-Server",
    "Web-Request-Monitor",
    "WAS-Process-Model",
    "WAS-Config-APIs",
    "Web-Mgmt-Tools",
    "Web-Net-Ext45",
    "Web-Asp-Net45",
    "Web-Windows-Auth",
    "NET-WCF-HTTP-Activation45",
    "RSAT-AD-PowerShell"
)
 
# Check feature status
$result = foreach ($feature in $features) {
    $featureStatus = Get-WindowsFeature -Name $feature
    [PSCustomObject]@{
        FeatureName = $feature
        Installed   = $featureStatus.Installed
    }
}
 
# Display result in table format
$result | Format-Table -AutoSize
