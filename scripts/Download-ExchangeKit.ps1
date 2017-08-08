[CmdletBinding()]

param(
    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeDownloadLink

)

try {
    Start-Transcript -Path C:\cfn\log\Download-ExchangeKit.ps1.txt -Append

    $ErrorActionPreference = "Stop"
    $DestPath = "C:\Exchangeinstall"
    New-Item "$DestPath" -Type directory -Force

    $tries = 5
    while ($tries -ge 1) {
        try {
            Start-BitsTransfer -Source $ExchangeDownloadLink -Destination "$DestPath" -ErrorAction Stop
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