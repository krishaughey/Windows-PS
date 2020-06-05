## Get Outlook Version
##### Get Outlook Version for files needed for Modern Authentication (MFA)
##### author: Kristopher F. Haughey

invoke-command -computername CARD01-6D9ZDW2 -ScriptBlock {(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\adal.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\csi.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\MSO.DLL").VersionInfo,(Get-ItemProperty "C:\Program Files (x86)\Microsoft Office\OFFICE15\outlook.exe").VersionInfo}
(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\adal.DLL").VersionInfo
(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\csi.DLL").VersionInfo
(Get-ItemProperty "C:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE15\MSO.DLL").VersionInfo
(Get-ItemProperty "C:\Program Files (x86)\Microsoft Office\OFFICE15\outlook.exe").VersionInfo
