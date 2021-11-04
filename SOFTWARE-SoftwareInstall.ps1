# Remotely installs software using XCOPY and PSEXEC
# REQUIRES the FUNCTION "SOFTWARE-FUNTION-GetRemoteProgram"
Import-Module -Name C:\Temp\SOFTWARE-FUNTION-GetRemoteProgram.ps1 -verbose

$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\NoS1AgentTEST.txt)

Foreach ($server in $list)
{
    xcopy \\FileServer\c$\Temp\InstallFileName.exe \\$server\c$\Temp\ /Y /D
    #Start-Sleep -s 10

    psexec \\$server "c:\Temp\InstallFileName.exe" /q /NOUI /norestart

    Get-RemoteProgram -ComputerName $Server -Property DisplayVersion | findstr Sentinel
}

#Get-RemoteProgram -ComputerName \\HOSTNAME.DomainName -Property DisplayVersion | findstr Sentinel

#psshutdown \\$server -r -e p:4:2
