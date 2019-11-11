#REQUIRES THE GET-REMOTEPROGRAM.PSM1
$ErrorActionPreference = 'silentlycontinue'

Import-Module -Name C:\Temp\Modules\Get-RemoteProgram -verbose

$list = (Get-Content C:\Temp\S1_CheckList.txt)

Foreach ($computer in $list)
{

  Get-RemoteProgram -ComputerName $computer -Property DisplayVersion | findstr Sentinel

  }
 
