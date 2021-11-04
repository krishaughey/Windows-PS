#Delete files in a directory on a remote machine (recursive)
Get-ChildItem –Path "\\HOST_FQDN\c$\Windows\servicing\Packages" –Recurse -Include *.EXTENSION | Where-Object CreationTime –lt (Get-Date).AddDays(-365) | Remove-Item
