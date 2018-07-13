[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]
    $DomainAdminUser,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeServerVersion,

    [Parameter(Mandatory=$true)]
    [string]
    $SSMParamName
)


try {
    Start-Transcript -Path C:\cfn\log\Install-ExchangeOrg.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = (Get-SSMParameterValue -Names $SSMParamName -WithDecryption $True).Parameters[0].Value
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

    # Make parameter secure string
    Write-SSMParameter -Name $SSMParamName -Type SecureString -Value $DomainAdminPassword -Overwrite $true

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
