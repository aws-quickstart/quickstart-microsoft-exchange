[CmdletBinding()]
param()

try {
    Start-Transcript -Path C:\cfn\log\Install-UCmaRuntime.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $Retries = 0
    $Installed = $false

    do {
        try {
            Invoke-Expression "C:\Exchangeinstall\UcmaRuntimeSetup.exe /passive /norestart" -ErrorAction Stop
            $installed = $true
        }
        catch {
            $exception = $_
            $retries++
            if ($retries -lt 6) {
                Write-Host $exception
                $linearBackoff = $retries * 60
                Write-Host "UcmaRuntime installation failed. Retrying in $linearBackoff seconds."
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