# Extending your PowerShell history

## Background
PowerShell history (Get-History) only stores cmdlets from the current session.  
Sometimes, it happens you run some fancy cmdlets, or mini scripts that you write on-the-fly, and you do not save.  
You might find them valuable the next day, after your session is no longer active.  
Digging through your (Get-PSReadlineOption).HistorySavePath file is time consuming and not encouraging.  
Using these 2 functions simplifies the job.

## Overview
Two utility functions for enhanced PowerShell command history management:

### `Get-PSReadLineHistory`
Parses and retrieves cmdlets from the PSReadLine history file.

#### Features
- Handles multi-line commands
- Reconstructs complex command entries
- Returns an array of parsed cmdlets

#### Usage
```powershell
$extendedHistory = Get-PSReadLineHistory
```

### `Invoke-FullHistory`
Runs or displays the selected cmdlets from history.

#### Features
- Interactive grid view for command selection
- Optional command filtering
- Flexible execution modes

#### Parameters
- `InputHistory`: Required array of cmdlet strings
- `Filter`: Optional wildcard filter for commands
- `DoNotExecute`: Optional switch to prevent command execution

#### Usage Examples
```powershell
# Execute filtered Git commands
Invoke-FullHistory -InputHistory $extendedHistory -Filter "Git*"

# Display commands without execution
Invoke-FullHistory -InputHistory $extendedHistory -DoNotExecute
```
## Import functions: 
Dot source the PS1 file:
```powershell
. .\Extend-PowerShellHistory.ps1
```

## Requirements
- PowerShell 5.0+
- PSReadLine module 2.0+

