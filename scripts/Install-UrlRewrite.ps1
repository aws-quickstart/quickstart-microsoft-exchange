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
    $UrlRewriteLink,

    [Parameter(Mandatory=$true)]
    [string]
    $ExUserSecParam
)


try {
	Start-Transcript -Path C:\cfn\log\Install-UrlRewrite.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = ConvertFrom-Json -InputObject (Get-SECSecretValue -SecretId $ExUserSecParam).SecretString
    $DomainAdminCreds = (New-Object PSCredential($DomainAdminFullUser,(ConvertTo-SecureString $DomainAdminPassword.Password -AsPlainText -Force)))


    $InstallUrlRewritePs={
        $ErrorActionPreference = "Stop"
        $temp = $Using:UrlRewriteLink
        $filename = $temp.Substring($temp.LastIndexOf("/") + 1)
        $InstallPath = "C:\Exchangeinstall" + "\" + $filename
        $InstallArgs = "/i $InstallPath /qn /L*v C:\cfn\log\UrlRewrite_Installer.log"

		Start-Process msiexec.exe -args $InstallArgs -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\UrlRewriteInstallerOutput.txt" -RedirectStandardError "C:\cfn\log\UrlRewriteInstallerErrors.txt"

    }

    $Retries = 0
    $Installed = $false
	while (($Retries -lt 4) -and (!$Installed)) {
        try {

			Invoke-Command -Authentication Credssp -Scriptblock $InstallUrlRewritePs -ComputerName localhost -Credential $DomainAdminCreds
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