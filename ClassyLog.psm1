#Requires -Version 5.0

class ClassyLogger {

	[string] $logFile
	[bool] $logToScreen = $true
	[bool] $ShowDebug = $false
	[string] $DateFormat = "yyyy-MM-dd HH:mm:ss"
	[string] $DelimiterFirst = ' '
	[string] $DelimiterSecond = '>> '

	ClassyLogger([string]$LogFile, [bool]$LogToScreen) {
		$this.Init($LogFile, $LogToScreen)
	}
	
	[boolean] Init([string]$LogFile, [bool]$LogToScreen){
		if ($this.CreateLogFile($LogFile)){
			write-host "Logging to $LogFile"
			$this.logFile = $LogFile
		} else {
			return $false
		}
		$this.logToScreen = $logToScreen
			
		return $true
	}
	
	Log([string] $message, [logLevel] $level) {
		$date = Get-Date
		$dt = Get-Date -Format $this.DateFormat
		$tm = 
		$message = $dt + $this.DelimiterFirst + $level + $this.DelimiterSecond + $message
	
		if ($this.logToScreen){
			Write-Host $message
		} 

		$message | Out-File -Append -FilePath $this.logFile -Encoding ascii
	}

	Log([string] $Message) {
		$this.Log($Message, [LogLevel]::INF)
	}

	LogInfo([string] $Message) {
		$this.Log($Message, [LogLevel]::INF)
	}

	LogError([string] $Message) {
		$this.Log($Message, [LogLevel]::ERR)
	}

	LogWarn([string] $Message) {
		$this.Log($Message, [LogLevel]::WRN)
	}

	LogDebug([string] $Message) {
		if ($this.ShowDebug){
			$this.Log($Message, [LogLevel]::DBG)
		}
	}

	CMLog([string] $Message, [string] $Component, [string] $Context, [int] $type, [string] $thread, [string] $file ){
		   
		$date = (Get-Date -Format "MM-dd-yyyy hh:mm:ss.fff K") -split(' ')
		$dt = $date[0]
		$tm = $date[1]
		$tz = ([int]($date[2] -split(':'))[0])*60 + ([int]($date[2] -split(':'))[1])
		$logMessage = '<![LOG[' + $Message + ']LOG]!><time="' + $tm + $tz + '" date="' + $date + '" component="' + $Component + '" context="' + $Context + '" type="' + $type + '" thread="' + $thread + '" file="' + $file + '">'
	
		if ($this.logToScreen){
			Write-Host ($dt + ' ' + $tm + ' ' + $tz + ' >> ' + $message)
		} 

		$logMessage | Out-File -Append -FilePath $this.logFile -Encoding ascii
	}

	[boolean] CreateLogFile([string] $path){
		$dir = Split-Path -Path $path

		if (!(Test-Path  $dir)){
			Try {
				New-Item -Path $dir -ItemType Directory -ErrorAction Stop
			} Catch {
				write-output "Log directory does not exist, unable to create. Exception: $($_.Exception)"
				return $false
			}
		}

		if (Test-Path $path){
			return $true
		} else {
			Try {
				New-Item -ItemType File -Path $path
			} catch {
				write-output "Unable to create log file. Exception: $($_.Exception)"
				return $false
			}
		}
		return $true
	}
} #Class ClassyLogger

Enum LogLevel {
	DBG = 0
	INF = 1
	WRN = 2
	ERR = 3
} 
