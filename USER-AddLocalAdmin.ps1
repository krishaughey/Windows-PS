$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }

Add-Admin -ComputerName (Get-Content "c:\temp\Japan\JapanMachineList.txt") -NewAdmin 'Admin' -NewAdminPassword '********' -LogFile C:\Temp\Japan\JP_AddAdmin_LOG_$timestamp.txt
