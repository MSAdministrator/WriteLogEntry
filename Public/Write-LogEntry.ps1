<#
.Synopsis
   Used to create and output information from functions
.DESCRIPTION
   This function will write to a log file.  You can specify if the log type is:
        Informational (Info)
        Debugging (Debugging)
        Error (Error)
   This function will by default create a log file in the parent folder of the calling scope, but
   you can specify a seperate log location if you choose.
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’)\log.log
   
   The default parameter set for this function is the Info logging, but there are 2 other sets
        Debug
        Error
   
   Example output that this function will place into a log file is
        Function call
            Write-LogEntry -Info 'This is an informational log event'
        Output
            20170401T055438 [INFO]: This is an informational log event

        Function call
            Write-LogEntry -Debugging 'This is an debugging log event'
        Output
            20170401T055440 [DEBUG]: This is an debugging log event

        Function call
            Write-LogEntry -Error 'This is an error log event'
        Output
            20170401T055442 [ERROR]: This is an error log event

        Function call
            try { 
                do-something 
            } catch { 
                Write-LogEntry -Error 'This is an error log event' -ErrorRecord $Error[0] 
            }
        Output
            20170401T055444 [ERROR]: This is an error log event
            20170401T055444 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                                     function, script file, or operable program. Check the spelling of the name, `
                                     or if a path was included, verify that the path is correct and try again. `
                                     (CommandNotFoundException: :1 char:7)
.EXAMPLE
        Write-LogEntry -Info 'This is an informational log event'
        
        Output
        20170401T055438 [INFO]: This is an informational log event
.EXAMPLE
        Write-LogEntry -Debugging 'This is an debugging log event'
    
        Output
        20170401T055440 [DEBUG]: This is an debugging log event
.EXAMPLE
        Write-LogEntry -Error 'This is an error log event'
        
        Output
        20170401T055442 [ERROR]: This is an error log event
.EXAMPLE
        try { 
            do-something 
        } catch { 
            Write-LogEntry -Error 'This is an error log event' -ErrorRecord $Error[0] 
        }
    
        Output
        20170401T055444 [ERROR]: This is an error log event
        20170401T055444 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                                 function, script file, or operable program. Check the spelling of the name, `
                                 or if a path was included, verify that the path is correct and try again. `
                                 (CommandNotFoundException: :1 char:7)

.INPUTS
   System.String
   System.Management.Automation.ErrorRecord
.NOTES
   Name: Write-LogEntry
   Created by: Josh Rickard
   Created Date: 11/24/2016
.FUNCTIONALITY
   Write-LogEntry is a PowerShell helper function that will accept or create a log file and
   add strings based on severity, as well as parse $error[0] records for easy interpretation
   and readability.
#>
function Write-LogEntry
{
    [CmdletBinding(DefaultParameterSetName = '', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'https://github.com/MSAdministrator/WriteLogEntry',
                  ConfirmImpact='Medium')]
    [OutputType()]
    Param
    (
<<<<<<< HEAD:Public/Write-LogEntry.ps1
        # Information type of log entry
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   ParameterSetName = 'Info')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Alias("information")]
        [System.String]$Info,

        # Debug type of log entry
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   Position=0,
                   ParameterSetName = 'Debug')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.String]$Debugging,

        # Error type of log entry
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   Position=0,
                   ParameterSetName = 'Error')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.String]$Error,

=======
        # The error type of log entry
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [ValidateSet('Info','Debug','Error')]
        $Type,
        
        # Message to log
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true
                   )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.String]$Message,
>>>>>>> 7b62585ea1f5bebc1b17574393e0bea5184deeea:Write-LogEntry.ps1

        # The error record containing an exception to log
        [Parameter(Mandatory=$false, 
                   ValueFromPipelineByPropertyName=$true
                   )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        # Logfile location
        [Parameter(Mandatory=$false, 
<<<<<<< HEAD:Public/Write-LogEntry.ps1
                   ValueFromPipelineByPropertyName=$true, 
                   Position=2)]
=======
                   ValueFromPipelineByPropertyName=$true,  
                   ParameterSetName = 'LogFile')]
>>>>>>> 7b62585ea1f5bebc1b17574393e0bea5184deeea:Write-LogEntry.ps1
        [Alias("file", "location")]
        [System.String]$LogFile = "$($ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’))" + "\log.log",

        # Error type of log entry
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   ParameterSetName = 'EventLog')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int]$EventId,
        
        # Logfile location
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   ParameterSetName = 'EventLog')]
        [System.String]$Source
    )

    
    Begin
    {
        if (!(Test-Path -Path $LogFile))
        {
            try
            {
                New-Item -Path $LogFile -ItemType File -Force | Out-Null
            }
            catch
            {
                Write-Error -Message 'Error creating log file'
                break
            }
        }

        $mutex = New-Object -TypeName 'Threading.Mutex' -ArgumentList $false, 'MyInterprocMutex'
    } # end of Begin block
    Process
    {
        switch ($PSBoundParameters.Keys)
        {
            'Error' 
            {
                if ($Source)
                {
                    $props = @{
                        'LogName'='Application'
                        'EntryType'='Error'
                        'Message'=$Error
                        'Source'=$Source
                        'EventId'=$EventId
                    }

                    Write-EventLog @props
                }
                else
                {
                    $mutex.waitone() | Out-Null

                    Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [ERROR]: $Error"

                    $mutex.ReleaseMutex() | Out-Null
                }
                

                if ($PSBoundParameters.ContainsKey('ErrorRecord'))
                {
                    $Message = '{0} ({1}: {2}:{3} char:{4})' -f $ErrorRecord.Exception.Message,
                                                                $ErrorRecord.FullyQualifiedErrorId,
                                                                $ErrorRecord.InvocationInfo.ScriptName,
                                                                $ErrorRecord.InvocationInfo.ScriptLineNumber,
                                                                $ErrorRecord.InvocationInfo.OffsetInLine

                    if ($Source)
                    {
                        $props = @{
                            'LogName'='Application'
                            'EntryType'='Error'
                            'Message'=$Message
                            'Source'=$Source
                            'EventId'=$EventId
                        }

                        Write-EventLog @props
                    }
                    else
                    {
                        $mutex.waitone() | Out-Null
                        Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [ERROR]: $Message"
                        $mutex.ReleaseMutex() | Out-Null
                    }
                }
            }
            'Info' 
            {
                if ($Source)
                {
                    $props = @{
                        'LogName'='Application'
                        'EntryType'='Information'
                        'Message'=$Info
                        'Source'=$Source
                        'EventId'=$EventId
                    }

                    Write-EventLog @props
                }
                else
                {
                    $mutex.waitone() | Out-Null

                    Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [INFO]: $Info"
                
                    $mutex.ReleaseMutex() | Out-Null
                }
            }
            'Debugging' 
            {
                Write-Debug -Message "$Debugging"

                $mutex.waitone() | Out-Null
                
                Add-Content -Path $LogFile -Value "$((Get-Date).ToString('yyyyMMddThhmmss')) [DEBUG]: $Debugging"
                
                $mutex.ReleaseMutex() | Out-Null
            }
        }
    } # end of Process block
    End
    {
        # intentionally left blank
    } # end of End block
} # end of Write-LogEntry function