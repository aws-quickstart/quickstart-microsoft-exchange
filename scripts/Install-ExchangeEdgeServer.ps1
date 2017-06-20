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
    while (($Retries -lt 4) -and (!$Installed)) {
        try {
        
            Invoke-Command -Authentication Credssp -Scriptblock $InstallExchPs -ComputerName localhost -Credential $LocalAdminCreds
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


