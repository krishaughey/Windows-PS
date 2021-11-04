## Get Outlook Version
##### Get Outlook Version for files needed for Modern Authentication (MFA)
##### author: Kristopher F. Haughey
$ErrorActionPreference = 'silentlycontinue'
#Create the log
$TimeStamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Function LogWrite
{
Param ([string]$logstring)
Add-content $Logfile -value $logstring
}
$Logfile = "c:\Windows\Logs\Outlook-ADAL_Update.log"
LogWrite "Script Start= $TimeStamp"

#Set the variables
$ADAL = (Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\adal.dll").VersionInfo
$CSI = (Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\csi.dll").VersionInfo
$MSO = (Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\mso.dll").VersionInfo
$Outlook = (Get-ItemProperty "C:\Program Files (x86)\Microsoft Office\OFFICE15\Outlook.exe").VersionInfo
$adalMin = "1.0.2019.909"
$csiMin = "15.0.4625.1000"
$msoMin = "15.0.4625.1000"
$outlookMin = "15.0.4625.1000"

#If the the FileVersion is less than the minimun required version, install the patch(es) from the GPO script Startup folder
## ADAL.dll
if ([string]::IsNullOrEmpty($ADAL)){
  LogWrite "file ADAL.dll not found"
}elseif ($ADAL.FileVersion -lt $adalMin){
  Start-Process "\\DomainName.com\SysVol\DomainName.com\Policies\{D31AB378-BFB4-49AC-9EEF-64E8235F1DB3}\Machine\Scripts\Startup\ADAL.exe" -ArgumentList "/q" -NoNewWindow -Wait
  LogWrite "Installing ADAL.dll update"
}else {LogWrite "ADAL.dll meets/exceeds the minimum version. No update required"}

## CSI.dll
if ([string]::IsNullOrEmpty($CSI)){
  LogWrite "file CSI.dll not found"
}elseif ($CSI.FileVersion -lt $csiMin){
  Start-Process "\\DomainName.com\SysVol\DomainName.com\Policies\{D31AB378-BFB4-49AC-9EEF-64E8235F1DB3}\Machine\Scripts\Startup\CSI.exe" -ArgumentList "/q" -NoNewWindow -Wait
  LogWrite "Installing CSI.dll update"
}else {LogWrite "CSI.dll meets/exceeds the minimum version. No update required"}

# MSO.dll
if ([string]::IsNullOrEmpty($MSO)){
  LogWrite "file MSO.dll not found"
}elseif ($MSO.FileVersion -lt $msoMin){
  Start-Process "\\DomainName.com\SysVol\DomainName.com\Policies\{D31AB378-BFB4-49AC-9EEF-64E8235F1DB3}\Machine\Scripts\Startup\MSO.exe" -ArgumentList "/q" -NoNewWindow -Wait
  LogWrite "Installing MSO.dll update"
}else {LogWrite "MSO.dll meets/exceeds the minimum version. No update required"}

# Outlook.exe
if ([string]::IsNullOrEmpty($Outlook)){
  LogWrite "file Outlook.exe not found"
}elseif ($Outlook.FileVersion -lt $outlookMin){
  Start-Process "\\DomainName.com\SysVol\DomainName.com\Policies\{D31AB378-BFB4-49AC-9EEF-64E8235F1DB3}\Machine\Scripts\Startup\Outlook.exe" -ArgumentList "/q" -NoNewWindow -Wait
  LogWrite "Installing Outlook.exe update"
}else {LogWrite "Outlook.exe meets/exceeds the minimum version. No update required"}

LogWrite "Script End= $TimeStamp"
LogWrite ""
