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
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}