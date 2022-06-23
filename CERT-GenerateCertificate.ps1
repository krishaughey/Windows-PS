$Cert_Name = "SharePoint_Cert"
New-SelfSignedCertificate -DnsName $Cert_Name -CertStoreLocation Cert:\LocalMachine\My
$MyCert = Get-ChildItem -Path "cert:\LocalMachine\My" | Where-Object {$_.Subject -match $Cert_Name}
$Cert_TB = $MyCert.Thumbprint
Export-Certificate -Cert "Cert:\LocalMachine\My\$Cert_TB" -FilePath C:\$Cert_Name.cer
