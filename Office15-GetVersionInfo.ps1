## Outlook VersionInfo
##### Get version info on files related to Modern Authentication in Outlook

Invoke-Command -ComputerName (Read-Host -Input "Enter the hostname of the machine you wish to query -->") -ScriptBlock {(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\adal.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\csi.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\MSO.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Microsoft Office\OFFICE15\outlook.exe").VersionInfo | format-table -autosize}

Read-Host "Process complete - press ENTER to close"
