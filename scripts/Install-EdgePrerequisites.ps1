
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
    
    while (($Retries -lt 4) -and (!$Installed)) {
        if($ExchangeServerVersion -eq "2013") {	
            try {
            Install-WindowsFeature ADLDS -ErrorAction Stop
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
    
    elseif ($ExchangeServerVersion -eq "2016") {
        try {
        Install-WindowsFeature ADLDS -ErrorAction Stop
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
    
    
    }
    
    if (!$Installed) {
          throw $Exception
    }
    
}
catch {
    $_ | Write-AWSQuickStartException
}