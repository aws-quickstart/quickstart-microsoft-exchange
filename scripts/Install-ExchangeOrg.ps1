[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]
    $DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]
    $DomainAdminPassword,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeServerVersion
)


try {
    Start-Transcript -Path C:\cfn\log\Install-ExchangeOrg.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)


    $InstallExchPs={
        $ErrorActionPreference = "Stop"
        $InstallPath = "C:\Exchangeinstall\setup.exe"
        $ExchangeArgs = "/PrepareAD /OrganizationName:Exchange /IAcceptExchangeServerLicenseTerms"
        Start-Process $InstallPath -args $ExchangeArgs -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\ExchangeOrgInstallerOutput.txt" -RedirectStandardError "C:\cfn\log\ExchangeOrgInstallerErrors.txt"
    }

    $Retries = 0
    $Installed = $false

    do {
        try {
            Invoke-Command -Authentication Credssp -Scriptblock $InstallExchPs -ComputerName $env:COMPUTERNAME -Credential $DomainAdminCreds
            $installed = $true
        }
        catch {
            $exception = $_
            $retries++
            if ($retries -lt 6) {
                Write-Host $exception
                $linearBackoff = $retries * 60
                Write-Host "Exchange organization configuration failed. Retrying in $linearBackoff seconds."
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
