[CmdletBinding()]

param(

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion

)

try {
    Start-Transcript -Path C:\cfn\log\Download-ExchangeKit.ps1.txt -Append

    $ErrorActionPreference = "Stop"
    $DestPath = "C:\Exchangeinstall"
    New-Item "$DestPath" -Type directory -Force

    if($ExchangeServerVersion -eq "2013") {
        $source = "https://download.microsoft.com/download/7/B/9/7B91E07E-21D6-407E-803B-85236C04D25D/Exchange2013-x64-cu16.exe"
    }
    elseif ($ExchangeServerVersion -eq "2016") {
        $source = "https://download.microsoft.com/download/A/A/7/AA7F69B2-9E25-4073-8945-E4B16E827B7A/ExchangeServer2016-x64-cu5.iso"
    }
    

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