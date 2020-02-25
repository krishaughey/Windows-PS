# Windows-PS
> Windows environment PowerShell (non-AD specific)

> Simple Timestamp Variable
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

##### Navigate the Windows Registry like the file system
cd hkcu:

##### Search recursively for a certain string within files
dir –r | select string "searchforthis"

##### Find the five processes using the most memory
ps | sort –p ws | select –last 5

##### Cycle a service (stop, and then restart it) like DHCP
Restart-Service DHCP

##### List all items within a folder
Get-ChildItem – Force

##### Recurse over a series of directories or folders
Get-ChildItem –Force c:\directory –Recurse

##### Remove all files within a directory without being prompted for each
Remove-Item C:\tobedeleted –Recurse

##### Restart the current computer
(Get-WmiObject -Class Win32_OperatingSystem -ComputerName .).Win32Shutdown(2)
Collecting information

##### Get information about the make and model of a computer
Get-WmiObject -Class Win32_ComputerSystem

##### Get information about the BIOS of the current computer
Get-WmiObject -Class Win32_BIOS -ComputerName .

##### List installed hotfixes -- QFEs, or Windows Update files
Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName .

##### Get the username of the person currently logged on to a computer
Get-WmiObject -Class Win32_ComputerSystem -Property UserName -ComputerName .

##### Find just the names of installed applications on the current computer
Get-WmiObject -Class Win32_Product -ComputerName . | Format-Wide -Column 1

##### Get IP addresses assigned to the current computer
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Format-Table -Property IPAddress

##### Get a more detailed IP configuration report for the current machine
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

##### Find network cards with DHCP enabled on the current computer
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=true" -ComputerName .

##### Enable DHCP on all network adapters on the current computer
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName . | ForEach-Object -Process {$_.EnableDHCP()}
Software management

##### Install an MSI package on a remote computer
(Get-WMIObject -ComputerName TARGETMACHINE -List | Where-Object -FilterScript {$_.Name -eq "Win32_Product"}).Install(\\MACHINEWHEREMSIRESIDES\path\package.msi)

##### Upgrade an installed application with an MSI-based application upgrade package
(Get-WmiObject -Class Win32_Product -ComputerName . -Filter "Name='name_of_app_to_be_upgraded'").Upgrade(\\MACHINEWHEREMSIRESIDES\path\upgrade_package.msi)

##### Remove an MSI package from the current computer
(Get-WmiObject -Class Win32_Product -Filter "Name='product_to_remove'" -ComputerName . ).Uninstall()
Machine management

##### Remotely shut down another machine after one minute
Start-Sleep 60; Restart-Computer –Force –ComputerName TARGETMACHINE

##### Add a printer
(New-Object -ComObject WScript.Network).AddWindowsPrinterConnection("\\printerserver\hplaser3")

##### Remove a printer
(New-Object -ComObject WScript.Network).RemovePrinterConnection("\\printerserver\hplaser3 ")

##### Enter into a remote PowerShell session -- you must have remote management enabled
enter-pssession TARGETMACHINE

##### Use the PowerShell invoke command to run a script on a remote servers
invoke-command -computername machine1, machine2 -filepath c:\Script\script.ps1
Bonus command

To dismiss a process you can use the process ID or the process name. The -processname switch allows the use of wildcards. Here's how to stop the calculator:
Stop-Process -processname calc*
