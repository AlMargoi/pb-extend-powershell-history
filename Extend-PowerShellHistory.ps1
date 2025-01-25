function Get-PSReadLineHistory {
    <#
        .SYNOPSIS
        Parses and returns cmdlets from the PSReadLine history file.

        .DESCRIPTION
        Reads the PSReadLine history file and reconstructs multi-line cmdlets, returning them as a list.

        .OUTPUTS
        Array of strings representing parsed cmdlets.

        .EXAMPLE
        $historyCmdlets = Get-PSReadLineHistory
    #>

    # Get the path of the PSReadLine history file
    $historyFilePath = (Get-PSReadlineOption).HistorySavePath

    # Read the content of the history file
    $historyFileContent = Get-Content $historyFilePath

    # Initialize an array to store the parsed history cmdlets
    $parsedHistoryCmdlets = @()

    # Initialize the index
    $currentIndex = 0

    # Iterate through the history file content
    while ($currentIndex -lt $historyFileContent.Count) {
        if ($historyFileContent[$currentIndex].Contains("``")) {
            # Handle multi-line commands
            $multiLineCmdlet = ""
            $multiLineCmdlet += $historyFileContent[$currentIndex].Replace("``", "`n")
            $isMultiLineCmdlet = $true
            while ($isMultiLineCmdlet) {
                $currentIndex++
                if ($historyFileContent[$currentIndex].Contains("``")) {
                    $multiLineCmdlet += $historyFileContent[$currentIndex].Replace("``", "`n")
                }
                else {
                    $multiLineCmdlet += $historyFileContent[$currentIndex]
                    $currentIndex++
                    $isMultiLineCmdlet = $false
                }
            }

            # Add the parsed multi-line command to the array
            $parsedHistoryCmdlets += $multiLineCmdlet
        }
        else {
            # Add single-line commands directly to the array
            $parsedHistoryCmdlets += $historyFileContent[$currentIndex]
            $currentIndex++
        }
    }

    # Return the parsed history commands
    return $parsedHistoryCmdlets
}



Function Invoke-FullHistory {
    <#
        .SYNOPSIS
        Filters, displays, and optionally executes cmdlets from the provided history.

        .DESCRIPTION
        Allows users to filter and select commands from the input history via `Out-GridView`. 
        Commands can either be displayed or executed based on the provided parameters.
        The input should be the output of the Get-PSReadLineHistory function.

        .PARAMETER InputHistory
        A required array of strings representing the history of cmdlets.

        .PARAMETER Filter
        An optional string used to filter the history using a wildcard pattern.
        If none provided, it defaults to "*"

        .PARAMETER DoNotExecute
        An optional switch. If provided, selected commands will be displayed but not executed.
        You can then copy them, edit and eventually execute them. 

        .EXAMPLE
        Invoke-FullHistory -InputHistory $history -Filter "Git*" -DoNotExecute
        # Filters history for commands containing "git" commands, displays them, but does not execute.

        .EXAMPLE
        Invoke-FullHistory -InputHistory $history
        # Displays all history commands in Out-GridView for selection and executes the chosen ones.
    #>

    param (
        [Parameter(Mandatory=$true)]
        [string[]]$InputHistory,

        [Parameter(Mandatory=$false)]
        [string]$Filter = $null,

        [Parameter(Mandatory=$false)]
        [switch]$DoNotExecute
    )

    if($DoNotExecute){
        if($Filter){
            foreach($cmdlet in ($InputHistory | Where-Object -FilterScript {$_ -like $Filter} | Out-GridView -PassThru)){
                Write-Host $cmdlet -ForegroundColor GREEN
            }
        }else{
            foreach($cmdlet in ($InputHistory | Out-GridView -PassThru)){
                Write-Host $cmdlet -ForegroundColor GREEN
            }
        }
    }else{
        if($Filter){
            foreach($cmdlet in ($InputHistory | Where-Object -FilterScript {$_ -like $Filter} | Out-GridView -PassThru)){
                Write-Host "`n$cmdlet" -ForegroundColor GREEN
                Invoke-Expression $cmdlet
            }
        }else{
            foreach($cmdlet in ($InputHistory | Out-GridView -PassThru)){
                Write-Host "`n$cmdlet" -ForegroundColor GREEN
                Invoke-Expression $cmdlet
            }
        }
    }

}
