## System Hardware Information
##### Get Hardware Info from WMI of Local Computer - report to CSV
##### author: Kristopher F. Haughey

$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$hostname = hostname

Write-Host "Gathering hardware information from $hostname..." -ForegroundColor Cyan
$Array = @()
$BIOS = Get-CimInstance Win32_BIOS | Select-Object Caption,SerialNumber
$Chassis = Get-CimInstance CIM_Chassis | Select-Object Description
$Display = Get-CimInstance CIM_Display | Select-Object Name,MonitorManufacturer
$IPAddress = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.ipaddress -notlike $null}
$Memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
$OS = Get-CimInstance Win32_OperatingSystem | Select-Object CSName,Locale,Caption,Version
$Storage = Get-CimInstance Win32_LogicalDisk | Measure-Object -Property Size -Sum | % { [Math]::Round(($_.sum / 1GB)) } 
$SYS = Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer,Model

  $Array += New-Object PsObject -Property ([ordered]@{
    'Name' = $OS.CSName
    'Manufacturer' = $SYS.Manufacturer
    'Model' = $SYS.Model
    'Asset Type' = $Chassis.Description
    'Serial Number' = $BIOS.SerialNumber
    'Location' = $OS.Locale
    'IP Address' = $IPAddress.IPaddress[0]
    'Operating System' = $OS.Caption
    'Operating System Version' = $OS.Version
    'Firmware' = $BIOS.Caption
    'Storage Capacity' = $Storage
    'RAM' = $Memory
    'Monitor Manufacturer' =  $Display.Name[0]
    'Monitor Model' =  $Display.MonitorManufacturer[0]
    })

$Array | Export-Csv $ENV:USERPROFILE\Downloads\$hostname-SystemReport_$timestamp.csv -NoTypeInformation
Write-Host "Report Complete! $ENV:USERPROFILE\Downloads\$hostname-SystemReport_$timestamp.csv" -ForegroundColor Cyan
