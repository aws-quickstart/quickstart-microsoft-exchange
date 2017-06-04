[CmdletBinding()]

param()

try {
    Start-Transcript -Path C:\cfn\log\Download-UcmaRuntime.ps1.txt -Append

    $ErrorActionPreference = "Stop"

    $DestPath = "C:\Exchangeinstall"
    New-Item "$DestPath" -Type directory -Force

    
    $source = "http://download.microsoft.com/download/2/C/4/2C47A5C1-A1F3-4843-B9FE-84C0032C61EC/UcmaRuntimeSetup.exe"
   

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
