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
    $NetFrameworkDownloadLink,

    [Parameter(Mandatory=$true)]
    [string]
    $ExUserSecParam
)


try {
	Start-Transcript -Path C:\cfn\log\Install-NetFramework.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = ConvertFrom-Json -InputObject (Get-SECSecretValue -SecretId $ExUserSecParam).SecretString
    $DomainAdminCreds = (New-Object PSCredential($DomainAdminFullUser,(ConvertTo-SecureString $DomainAdminPassword.Password -AsPlainText -Force)))

    $InstallNetfwPs={
        $ErrorActionPreference = "Stop"
        $temp = $Using:NetFrameworkDownloadLink
        $filename = $temp.Substring($temp.LastIndexOf("/") + 1)
        $InstallPath = "C:\Exchangeinstall" + "\" + $filename
        $Args = "/q /norestart /log C:\cfn\log\NetFramework_Installer.htm"

		Start-Process $InstallPath -args $Args -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\NetFrameworkInstallerOutput.txt" -RedirectStandardError "C:\cfn\log\NetFrameworkInstallerErrors.txt"
    }

    $Retries = 0
    $Installed = $false
	while (($Retries -lt 4) -and (!$Installed)) {
        try {

			Invoke-Command -Authentication Credssp -Scriptblock $InstallNetfwPs -ComputerName localhost -Credential $DomainAdminCreds
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
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}