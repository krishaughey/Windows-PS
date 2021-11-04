## Changes the password of a local account against a LIST of servers. !!List needs to be in "C:\Temp\ServerList.txt"!!
## You will be PROMPTED to enter the username and password
## Report will be generated in "C:\Temp\($accountName)_Password.csv"
$computers = Get-Content -path "C:\Temp\ServerList.txt"
$accountName = Read-Host -prompt "Enter account you wish to change"
$password = Read-Host -prompt "Enter new password for user" -assecurestring
$decodedpassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
foreach ($Computer in $Computers) {
  $Computer = $Computer.toupper()
  $Isonline = "OFFLINE"
  $Status = "SUCCESS"
  $StatsError ="Failed"
  if((Test-Connection -ComputerName $Computer -count 1 -ErrorAction 0)) {
    $Isonline = "ONLINE"
  } else { $StatsError= "`t$Computer is OFFLINE" }

  try {
    $account = [ADSI]("WinNT://$Computer/$accountName")
    $account.psbase.invoke("setpassword",$decodedpassword)
    $StatsError="$accountName Password changed successfully"
  }
  catch {
    $status = "FAILED"
    $StatsError="$_"
  }

  $obj = New-Object -TypeName PSObject -Property @{
  ComputerName = $Computer
  IsOnline = $Isonline
  PasswordChangeStatus = $Status
  DetailedStatus=$StatsError
  }

  $obj | Select-Object ComputerName, IsOnline, PasswordChangeStatus,DetailedStatus
  $obj | Export-Csv -Append -Path "C:\Temp\($accountName)_Password.csv"
}
