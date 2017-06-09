[CmdletBinding()]
param()

try {
    Start-Transcript -Path C:\cfn\log\Install-NetFramework.ps1.txt -Append
    $ErrorActionPreference = "Stop"
	
	$Retries = 0
    $Installed = $false
	while (($Retries -lt 4) -and (!$Installed)) {
        try {
            Invoke-Expression "C:\Exchangeinstall\NDP462-KB3151800-x86-x64-AllOS-ENU.exe /q /norestart" -ErrorAction Stop
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