## Resolve External DNS
##### Resolve External DNS from list of domain names using Google and Open DnsName
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

## if you have a short list ---> $DomainNames = @('adamtheautomator.com','powershell.org','xyz.local')
$DomainNames = get-content c:\Temp\WebsiteList.txt
$ServerList = @('8.8.8.8','8.8.4.4','208.67.222.222','208.67.220.220')

$DataSet = @()
foreach ($Name in $DomainNames) {
    $TempObject = "" | Select-Object Name,IPAddress,Status,ErrorMessage
    try {
        $dnsRecord = Resolve-DnsName $Name -Server $ServerList -ErrorAction Stop | Where-Object {$_.Type -eq 'A'}
        $TempObject.Name = $Name
        $TempObject.IPAddress = ($dnsRecord.IPAddress -join ',')
        $TempObject.Status = 'OK'
        $TempObject.ErrorMessage = ''
    }
    catch {
        $TempObject.Name = $Name
        $TempObject.IPAddress = ''
        $TempObject.Status = 'ERROR'
        $TempObject.ErrorMessage = $_.Exception.Message
    }
    $DataSet += $TempObject
}
$DataSet | export-csv c:\Temp\ExternalDNS_$Timestamp.csv -NoTypeInformation
