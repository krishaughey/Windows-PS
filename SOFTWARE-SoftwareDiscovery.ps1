# REQUIRES THE GETREMOTEPROGRAM FUNCTION
$ErrorActionPreference = 'silentlycontinue'

Import-Module -Name C:\Temp\Modules\Get-RemoteProgram -verbose

$list = (Get-Content C:\Temp\S1_CheckList.txt)

Foreach ($computer in $list)
{

  Get-RemoteProgram -ComputerName $computer -Property DisplayVersion | findstr Sentinel

  }
