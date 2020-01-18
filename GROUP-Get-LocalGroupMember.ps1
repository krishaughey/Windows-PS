Function Get-LocalGroupMember {
    <#
        .SYNOPSIS
            Used to query local groups on local or remote systems and determine group membership and if
            members are valid.

        .DESCRIPTION
            Used to query local groups on local or remote systems and determine group membership and if
            members are valid. Returns a TRUE or FALSE if members are valid for group.

        .PARAMETER Computername
            List of computers to run the query against

        .PARAMETER Group
            Name of group to query for membership

        .PARAMETER ValidMember
            Known good members of group to return a value of True for isValid property

        .PARAMETER Throttle
            Number of concurrently running jobs to run at a time

        .NOTES
            Author: Boe Prox
            Name: Get-LocalGroupMember
            Date Created: 22 JAN 2013
            Last Modified: 22 JAN 2013
                Version 1.0 - Initial Creation            

        .EXAMPLE
            Get-LocalGroupMember -ValidMember "Administrator","Domain Admins"

            Group          Computername IsValid Account
            -----          ------------ ------- -------
            Administrators computer1       True Administrator
            Administrators computer1       True Domain Admins

            Description
            -----------
            Script run using default parameters of localhost for computername to search for local 
            Administrators group with a default set excluded members.

        .EXAMPLE
            Get-LocalGroupMember -Computername 'Server1',Server2' -Group Administrators -ValidMember "User1","Domain Admins","Administrator"

            Group          Computername IsValid Account
            -----          ------------ ------- -------
            Administrators Server1       True   Administrator
            Administrators Server1       False  User2
            Administrators Server1       True   User1
            Administrators Server1       True   Domain Admins
            Administrators Server2       True   User1
            Administrators Server2       False  BobSmith
            Administrators Server2       True   Administrator
            Administrators Server2       False  User2

            Description
            -----------
            Script run using default parameters of localhost for computername to search for local 
            Administrators group with a default set excluded members.
    #>

    [cmdletbinding()]
    #region Parameters
    Param (
        [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [Alias("Computer","__Server","IPAddress","CN","dnshostname")]
        [string[]]$Computername = $env:COMPUTERNAME,
        [parameter()]
        [string]$Group = 'Administrators',
        [parameter()]
        [string[]]$ValidMember,
        [parameter()]
        [Alias("MaxJobs")]
        [int]$Throttle = 10
    )
    #endregion Parameters
    Begin {
        #region Functions
        #Function to perform runspace job cleanup
        Function Get-RunspaceData {
            [cmdletbinding()]
            param(
                [switch]$Wait
            )
            Do {
                $more = $false         
                Foreach($runspace in $runspaces) {
                    If ($runspace.Runspace.isCompleted) {
                        $runspace.powershell.EndInvoke($runspace.Runspace)
                        $runspace.powershell.dispose()
                        $runspace.Runspace = $null
                        $runspace.powershell = $null                 
                    } ElseIf ($runspace.Runspace -ne $null) {
                        $more = $true
                    }
                }
                If ($more -AND $PSBoundParameters['Wait']) {
                    Start-Sleep -Milliseconds 100
                }   
                #Clean out unused runspace jobs
                $temphash = $runspaces.clone()
                $temphash | Where {
                    $_.runspace -eq $Null
                } | ForEach {
                    Write-Verbose ("Removing {0}" -f $_.computer)
                    $Runspaces.remove($_)
                }             
            } while ($more -AND $PSBoundParameters['Wait'])
        }
        #endregion Functions
    
        #region Splat Tables
        #Define hash table for Get-RunspaceData function
        $runspacehash = @{}

        $testConnectionHash = @{
            Count = 1
            Quiet = $True
        }

        #endregion Splat Tables

        #region ScriptBlock
        $scriptBlock = {
            Param ($Computer,$Group,$ValidMember,$testConnectionHash)
            Write-Verbose ("{0}: Testing if online" -f $Computer)
            $testConnectionHash.Computername = $Computer
            If (Test-Connection @testConnectionHash) {
		        $adsicomputer = [ADSI]("WinNT://$Computer,computer")
    	        $localgroup = $adsicomputer.children.find($Group)
                If ($localGroup) {
    	            $localgroup.psbase.invoke("members") | ForEach {
                        Try {
                            $member = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
                            If ($ValidMember -notcontains $member) {
                                New-Object PSObject -Property @{
                                    Computername = $Computer
                                    Group = $Group
                                    Account = $member
                                    IsValid = $FALSE
                                }
                            } Else {
                                New-Object PSObject -Property @{
                                    Computername = $Computer
                                    Group = $Group
                                    Account = $member
                                    IsValid = $TRUE
                                }
                            }
                        } Catch {
                            Write-Warning ("{0}: {1}" -f $Computer,$_.exception.message)
                        }
                    }
                } Else {
                    Write-Warning ("{0} does not exist on {1}!" -f $Group,$Computer)
                }
            } Else {
                Write-Warning ("{0}: Unable to connect!" -f $Computer)
            }           
        }
        #endregion ScriptBlock

        #region Runspace Creation
        Write-Verbose ("Creating runspace pool and session states")
        $sessionstate = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
        $runspacepool = [runspacefactory]::CreateRunspacePool(1, $Throttle, $sessionstate, $Host)
        $runspacepool.Open()  
        
        Write-Verbose ("Creating empty collection to hold runspace jobs")
        $Script:runspaces = New-Object System.Collections.ArrayList        
        #endregion Runspace Creation
    }
    Process {
        ForEach ($Computer in $Computername) {
            #Create the powershell instance and supply the scriptblock with the other parameters 
            $powershell = [powershell]::Create().AddScript($scriptBlock).AddArgument($computer).AddArgument($Group).AddArgument($ValidMember).AddArgument($testConnectionHash)
           
            #Add the runspace into the powershell instance
            $powershell.RunspacePool = $runspacepool
           
            #Create a temporary collection for each runspace
            $temp = "" | Select-Object PowerShell,Runspace,Computer
            $Temp.Computer = $Computer
            $temp.PowerShell = $powershell
           
            #Save the handle output when calling BeginInvoke() that will be used later to end the runspace
            $temp.Runspace = $powershell.BeginInvoke()
            Write-Verbose ("Adding {0} collection" -f $temp.Computer)
            $runspaces.Add($temp) | Out-Null
           
            Write-Verbose ("Checking status of runspace jobs")
            Get-RunspaceData @runspacehash        
        }
    }
    End {
        Write-Verbose ("Finish processing the remaining runspace jobs: {0}" -f (@(($runspaces | Where {$_.Runspace -ne $Null}).Count)))
        $runspacehash.Wait = $true
        Get-RunspaceData @runspacehash
    
        #region Cleanup Runspace
        Write-Verbose ("Closing the runspace pool")
        $runspacepool.close()  
        $runspacepool.Dispose() 
        #endregion Cleanup Runspace
    } 
}