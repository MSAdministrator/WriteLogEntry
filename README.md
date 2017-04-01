# WriteLogEntry
A PowerShell helper function to create and write information to a log file

## Synopsis
Used to create and output information from functions
## DESCRIPTION
This function will write to a log file.  You can specify if the log type is:
        Informational (Info)
        Debugging (Debugging)
        Error (Error)
   This function will by default create a log file in the parent folder of the calling scope, but
   you can specify a seperate log location if you choose.
```
$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(‘.\’)\log.log
```
   
   The default parameter set for this function is the Info logging, but there are 2 other sets
        Debug
        Error
   
## EXAMPLE
   Function call
```
Write-LogEntry -Info 'This is an informational log event'
```
    Output
```
20170401T055438 [INFO]: This is an informational log event
```
## EXAMPLE
   Function call
```
Write-LogEntry -Debugging 'This is an debugging log event'
```
    Output
```
20170401T055440 [DEBUG]: This is an debugging log event
```
## EXAMPLE
    Function call
```
Write-LogEntry -Error 'This is an error log event'
```
    Output
```
20170401T055442 [ERROR]: This is an error log event
```
## EXAMPLE
    Function call
```
try { 
   do-something 
} catch { 
   Write-LogEntry -Error 'This is an error log event' -ErrorRecord $Error[0] 
}
```
    Output
```
20170401T055444 [ERROR]: This is an error log event
20170401T055444 [ERROR]: The term 'do-something' is not recognized as the name of a cmdlet, `
                         function, script file, or operable program. Check the spelling of the name, `
                         or if a path was included, verify that the path is correct and try again. `
                         (CommandNotFoundException: :1 char:7)
```

## INPUTS
```
System.String
System.Management.Automation.ErrorRecord
```
## NOTES
   Name: Write-LogEntry
   Created by: Josh Rickard
   Created Date: 04/01/2017
## FUNCTIONALITY
   Write-LogEntry is a PowerShell helper function that will accept or create a log file and
   add strings based on severity, as well as parse $error[0] records for easy interpretation
   and readability.