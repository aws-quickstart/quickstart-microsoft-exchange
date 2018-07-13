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
    $SSMParamName,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion,

    [string]
    [Parameter(Mandatory=$true)]
    $ServerIndex
)

try {
    Start-Transcript -Path C:\cfn\log\Install-Exchange.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = (Get-SSMParameterValue -Names $SSMParamName -WithDecryption $True).Parameters[0].Value
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

    $InstallExchPs={
        $ErrorActionPreference = "Stop"
        $InstallPath = "C:\Exchangeinstall\setup.exe"

        if($Using:ExchangeServerVersion -eq "2013") {
            $ExchangeArgs = "/mode:Install /OrganizationName:Exchange /role:ClientAccess,Mailbox /MdbName:DB$Using:ServerIndex /DbFilePath:D:\Databases\DB$Using:ServerIndex\DB$Using:ServerIndex.edb /LogFolderPath:E:\Databases\DB$Using:ServerIndex /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms"
        }
        elseif ($Using:ExchangeServerVersion -eq "2016") {
            $ExchangeArgs = "/mode:Install /OrganizationName:Exchange /role:Mailbox /MdbName:DB$Using:ServerIndex /DbFilePath:D:\Databases\DB$Using:ServerIndex\DB$Using:ServerIndex.edb /LogFolderPath:E:\Databases\DB$Using:ServerIndex /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms"
        }

        Start-Process $InstallPath -args $ExchangeArgs -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\ExchangeServerInstallerOutput.txt" -RedirectStandardError "C:\cfn\log\ExchangeServerInstallerErrors.txt"
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
                Write-Host "Exchange Installation failed. Retrying in $linearBackoff seconds."
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
