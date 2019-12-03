
[CmdletBinding()]

param(

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion

)

try {
    Start-Transcript -Path C:\cfn\log\Install-EdgePrerequisites.ps1.txt -Append
    $ErrorActionPreference = "Stop"
    $Retries = 0
    $Installed = $false

    do {
        try {
            if($ExchangeServerVersion -eq "2016") {
               Install-WindowsFeature ADLDS -ErrorAction Stop
               $Installed = $true
            }

            elseif ($ExchangeServerVersion -eq "2019") {
               Install-WindowsFeature ADLDS -ErrorAction Stop
               $Installed = $true
            }
        }
        catch {
            $exception = $_
            $retries++
            if ($retries -lt 6) {
                Write-Host $exception
                $linearBackoff = $retries * 60
                Write-Host "Edge prerequisites installation failed. Retrying in $linearBackoff seconds."
                Start-Sleep -Seconds $linearBackoff
            }
        }
    } while (($retries -lt 6) -and (-not $installed))
    if (-not $installed) {
          throw $exception
    }
}
catch {
    $_ | Write-AWSQuickStartException
}