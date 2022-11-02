# REQUIRES THE GETREMOTEPROGRAM FUNCTION
#$ErrorActionPreference = 'silentlycontinue'
Import-Module "c:\Temp\Scripts\Modules\SOFTWARE-FUNCTION-GetRemoteProgram.ps1"
$colItems = get-adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase "OU=Servers,DC=<Domain>,DC=COM"| Select-Object Name
$Array = @()
foreach ($S in $colItems) {
	Get-RemoteProgram -computername $S.Name -IncludeProgram 'Sophos Endpoint Agent'
  $Array += New-Object PSObject -Property ( [ordered]@{
      'ComputerName' = $Server
      'KeyPath' = $KeyValue.ProgramName } )
}
$Array | Export-CSV c:\Temp\SophosAgentInstall.csv -NoTypeInformation
