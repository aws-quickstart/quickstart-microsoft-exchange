[CmdletBinding()]

param()

try {
    Start-Transcript -Path C:\cfn\log\Download-NetFramework.ps1.txt -Append

    $ErrorActionPreference = "Stop"

    $DestPath = "C:\Exchangeinstall"
    New-Item "$DestPath" -Type directory -Force

    
    $source = "https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
   

    $tries = 5
    while ($tries -ge 1) {
        try {
            Start-BitsTransfer -Source $source -Destination "$DestPath" -ErrorAction Stop
            break
        }
        catch {
            $tries--
            Write-Verbose "Exception:"
            Write-Verbose "$_"
            if ($tries -lt 1) {
                throw $_
            }
            else {
                Write-Verbose "Failed download. Retrying again in 5 seconds"
                Start-Sleep 5
            }
        }
    }
}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}
