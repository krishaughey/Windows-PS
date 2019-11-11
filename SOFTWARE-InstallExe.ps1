$ErrorActionPreference= 'silentlycontinue'
$list = (Get-Content C:\Temp\NoS1AgentTEST.txt)

Foreach ($server in $list)
{
    xcopy \\padm075\c$\Temp\SentinelAgent_windows_v3_2_4_54.exe \\$server\c$\Temp\ /Y /D
    #Start-Sleep -s 10

    psexec \\$server "c:\Temp\SentinelAgent_windows_v3_2_4_54.exe" /q /NOUI /norestart /SITE_TOKEN=eyJ1cmwiOiAiaHR0cHM6Ly9nYW5uZXR0LnNlbnRpbmVsb25lLm5ldCIsICJzaXRlX2tleSI6ICI2YjlmZmQxMTMzMmQ2N2FiIn0=

    Get-RemoteProgram -ComputerName $Server -Property DisplayVersion | findstr Sentinel
}

#Get-RemoteProgram -ComputerName \\HOSTNAME.rlcorp.local -Property DisplayVersion | findstr Sentinel

#psshutdown \\$server -r -e p:4:2
