# ClassyLog Powershell Module
Classylog is a logging module that can write logs in a simple or [CMTrace](https://docs.microsoft.com/en-us/sccm/core/support/cmtrace) format. The advantage of this module is that the log settings are stored in an object.

## Import the module and create an instace of the class
```Powershell
Import-Module '.\ClassyLog.psm1' -Force
$log = & (Get-Module ClassyLog).NewBoundScriptBlock({[ClassyLogger]::new("c:\logs\test.log", $true)})
```

## Write to the log in the basic format
```Powershell
$log.Log("The thing is all good")
$log.LogError("Unable to do the thing")
$log.LogWarn("You should probably do something about the thing")

$log.ShowDebug = $true
$log.LogDebug("I created the thing")
```

## Write in CMTrace format
```Powershell
$log.CMLog("ConfigMgr FTW", 'TESTING', '', 1, '', "test.ps1")
```

## Other options
### Disable logging to screen.
```Powershell
$log.logToScreen = $true
```

### Show debuging, disabled by default
```Powershell
$log.ShowDebug = $false
```

### Adjust the date format.
```Powershell
$log.DateFormat = "yyyy-MM-dd HH:mm:ss"
```
### Set the delimiter between the date and the log level
```Powershell
$log.DelimiterFirst = '::'
```

### Set the delimiter between the log level and the message
```Powershell
[string] $DelimiterSecond = '>> '
```