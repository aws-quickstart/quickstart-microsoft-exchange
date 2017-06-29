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
    while (($Retries -lt 4) -and (!$Installed)) {
        try {
            Invoke-Command -Authentication Credssp -Scriptblock $InstallExchPs -ComputerName localhost -Credential $DomainAdminCreds
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