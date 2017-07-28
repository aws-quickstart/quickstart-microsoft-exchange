[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $EdgeNodeNetBIOSName,
    
    [Parameter(Mandatory=$true)]
    [string]
    $DomainAdminPassword,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion

)

try {
    Start-Transcript -Path C:\cfn\log\Install-ExchangeEdgeServer.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $LocalAdminFullUser = $EdgeNodeNetBIOSName + '\Administrator'
    $LocalAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $LocalAdminCreds = New-Object System.Management.Automation.PSCredential($LocalAdminFullUser, $LocalAdminSecurePassword)

    $InstallExchPs={
        $ErrorActionPreference = "Stop"
        $InstallPath = "C:\Exchangeinstall\setup.exe"

        if($Using:ExchangeServerVersion -eq "2013") {	
            $ExchangeArgs = "/mode:Install /role:EdgeTransport /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms"
        }
        elseif ($Using:ExchangeServerVersion -eq "2016") {
            $ExchangeArgs = "/mode:Install /role:EdgeTransport /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms"
        }
        
        Start-Process $InstallPath -args $ExchangeArgs -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\ExchangeEdgeInstallerOutput.txt" -RedirectStandardError "C:\cfn\log\ExchangeEdgeInstallerErrors.txt"
    }

    $Retries = 0
    $Installed = $false

    do {
        try {
            Invoke-Command -Authentication Credssp -Scriptblock $InstallExchPs -ComputerName localhost -Credential $LocalAdminCreds
            $installed = $true
        }
        catch {
            $exception = $_
            $retries++
            if ($retries -lt 6) {
                Write-Host $exception
                $linearBackoff = $retries * 60
                Write-Host "Edge role installation failed. Retrying in $linearBackoff seconds."
                Start-Sleep -Seconds $linearBackoff
            }
        }
    } while (($retries -lt 6) -and (-not $installed))
    if (-not $installed) {
          throw $exception
    }    
}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}