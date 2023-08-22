# Windows-PS
## QUICK REFERENCE
![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Simple Timestamp Variable
> $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

## General
##### Clear Stored Credentials
    cmdkey /list

Currently stored credentials:

    Target: LegacyGeneric:target=adm-khaughey-arbonnewest.com
    Type: Generic
    User: arbonnewest.com\adm-khaughey
    Saved for this logon only

    Target: LegacyGeneric:target=adm-khaughey-arbonne.aws
    Type: Generic
    User: arbonne.aws\adm-khaughey
    Saved for this logon only

    cmdkey /delete:adm-khaughey-arbonnewest.com

CMDKEY: Credential deleted successfully.

##### Get text string from multiple files in directory
    Get-ChildItem .\ *.* -R | Select-String <string>

##### Combine Multiple CSV files
    Get-ChildItem -Filter *.csv | Import-Csv | Export-Csv .\merged.csv -NoTypeInformation -Append

##### Copy Files from Remote Computer via WinRM/PSSession
    Copy-Item -FromSession (New-PSSession –ComputerName <REMOTE HOSTNAME> -Credential Get-Credential) -Path "<REMOTE HOSTNAME\FILE>" -destination <LOCAL PATH>
    
##### Get Service (no disabled, no LocalSystem acct)
    get-wmiobject win32_service | where {$_.StartName -ne "LocalSystem" -and $_.StartMode -ne "Disabled"} | format-table Name,DisplayName,State,StartMode,StartName

##### Get Running Services
    gsv | where {$_.Status -eq "Running"}

##### Get Installed Windows Updates
	get-wmiobject -class win32_quickfixengineering

##### Get all Volume ID
    GWMI -namespace root\cimv2 -class win32_volume | FL -property DriveLetter, DeviceID

##### Get OS Version number, build, and revision
    ` [System.Environment]::OSVersion.Version `
	
##### Get BIOS Information
	gwmi -class WIN32_Bios

##### Get the five processes using the most memory
    ps | sort –p ws | select –last 5

##### Get Service Accounts
    Get-WMIObject Win32_Service -filter "startname='domain\\username'"

##### Get the Up Time of a remote server
    (Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName TS02).LastBootupTime

##### Recurse over a series of directories or folders
    Get-ChildItem –Force \\<ServerName>\<PathName> –Recurse

## Get WMI Object Data
##### Restart the current computer
    (Get-WmiObject -Class Win32_OperatingSystem -ComputerName .).Win32Shutdown(2)

##### Get information about the make and model of a computer
    Get-WmiObject -Class Win32_ComputerSystem

##### Get information about the BIOS of the current computer
    Get-WmiObject -Class Win32_BIOS -ComputerName .

##### List installed hotfixes -- QFEs, or Windows Update files
    Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName .

##### Get the username of the person currently logged on to a computer
    Get-WmiObject -Class Win32_ComputerSystem -Property UserName -ComputerName .

##### Get installed applications on the current computer
    Get-WmiObject -Class Win32_Product -ComputerName . | Format-Wide -Column 1

##### Get IP addresses assigned to the current computer
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Format-Table -Property IPAddress

##### Get a more detailed IP configuration report for the current machine
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

##### Get network cards with DHCP enabled on the current computer
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=true" -ComputerName .

##### Enable DHCP on all network adapters on the current computer
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName . | ForEach-Object -Process {$_.EnableDHCP()}

## Software management
##### Install an MSI package on a remote computer
    (Get-WMIObject -ComputerName TARGETMACHINE -List | Where-Object -FilterScript {$_.Name -eq "Win32_Product"}).Install(\\<ServerName>\<PATH>\<FileName>.msi)

##### Upgrade an installed application with an MSI-based application upgrade package
    (Get-WmiObject -Class Win32_Product -ComputerName . -Filter "Name='name_of_app_to_be_upgraded'").Upgrade(\\<ServerName>\<PATH>\<UpgradePackageName>.msi)

##### Remove an MSI package from the current computer
    (Get-WmiObject -Class Win32_Product -Filter "Name='<PackageName>'" -ComputerName . ).Uninstall()

## Machine management
##### Remotely shut down another machine after one minute
    Start-Sleep 60; Restart-Computer –Force –ComputerName <ServerName>

##### Add a printer
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\<ServerName>\<PrinterName>")

##### Remove a printer
    (New-Object -ComObject WScript.Network).RemovePrinterConnection("\\<ServerName>\<PrinterName>")
