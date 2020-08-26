# Windows-PS
## QUICK REFERENCE
![PowerShell](https://repository-images.githubusercontent.com/221074232/158c2480-5262-11ea-8af0-452a86d9e56d)

##### Simple Timestamp Variable
> $timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

## General

##### Get Installed Windows Updates
	get-wmiobject -class win32_quickfixengineering

##### Get all Volume ID
    GWMI -namespace root\cimv2 -class win32_volume | FL -property DriveLetter, DeviceID

##### Get OS Version number, build, and revision
    ` [System.Environment]::OSVersion.Version `

##### Get the five processes using the most memory
    ps | sort –p ws | select –last 5

##### Stop a process by name
    Stop-Process -processname <ProcessName*>

##### Cycle a service
    Restart-Service <ServiceName>

##### Get Service Accounts
    Get-WMIObject Win32_Service -filter "startname='domain\\username'"

##### Get all items within a folder
    Get-ChildItem – Force

##### Get the Up Time of a remote server
    (Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName TS02).LastBootupTime

##### Recurse over a series of directories or folders
    Get-ChildItem –Force \\<ServerName>\<PathName> –Recurse

##### Remove all files within a directory without being prompted for each
    Remove-Item <PATH> –Recurse

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

##### Enter into a remote PowerShell session -- you must have remote management enabled
    enter-pssession <ServerName>

##### Use the PowerShell invoke command to run a script on a remote servers
    invoke-command -computername <ServerName>, <ServerName02> -ScriptBlock {get-process}
