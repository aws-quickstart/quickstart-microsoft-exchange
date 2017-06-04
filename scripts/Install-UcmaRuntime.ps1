[CmdletBinding()]
param()

try {
    Start-Transcript -Path C:\cfn\log\Install-UCmaRuntime.ps1.txt -Append
    $ErrorActionPreference = "Stop"
	
	$installer = "C:\Exchangeinstall\UcmaRuntimeSetup.exe"
	$arguments = "/passive /norestart"
	
	$Retries = 0
    $Installed = $false
	while (($Retries -lt 4) -and (!$Installed)) {
        try {
            Invoke-Expression "C:\Exchangeinstall\UcmaRuntimeSetup.exe /passive /norestart" -ErrorAction Stop
            $Installed = $true
        }
        catch {
            $Exception = $_
            $Retries++
            if ($Retries -lt 4) {
                Start-Sleep ($Retries * 60)
            }
        }
    }
    if (!$Installed) {
          throw $Exception
    }
	
}
catch {
    $_ | Write-AWSQuickStartException
}