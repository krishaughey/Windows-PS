# REQUIRES THE GETREMOTEPROGRAM FUNCTION
#$ErrorActionPreference = 'silentlycontinue'
$Module = Read-Host -Input "enter the module 'GetRemotProgram path'"
Import-Module -Name $Module -Verbose
$list = (Get-Content C:\Temp\ServList.txt)

Foreach ($computer in $list)
{
  Get-RemoteProgram -ComputerName $computer -Property DisplayVersion | findstr Sentinel
  }
