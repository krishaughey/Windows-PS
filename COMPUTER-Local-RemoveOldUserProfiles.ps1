Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false }
$oldProfiles = Get-WmiObject Win32_UserProfile | Where-Object { $_.LastUseTime -lt (Get-Date).AddDays(-90) }
$oldProfiles | Select-Object LocalPath, LastUseTime
foreach ($profile in $oldProfiles) {
    $profile.Delete()
}
$Error[0] | Format-List -Force
Out-File -FilePath "C:\Temp\ProfileDeletion.log" -Append -InputObject "Deleted $profile.LocalPath on $(Get-Date)"
