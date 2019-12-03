# Get-Process = gps

#Get local processes' name and pageable memory in MB with 2 decimals
Get-Process | select Name, @{n='Pageable Memory (MB)'; e={ '{0:N2}' -f ($PSItem.PM / 1MB)}}

#Get local processes by conditions
Get-Process | Where { $PSItem.CPU –gt 30 –and $PSItem.VM –lt 10000 }
Get-Process | Where { $PSItem.CPU –gt 30 –or $PSItem.VM –lt 10000 }
