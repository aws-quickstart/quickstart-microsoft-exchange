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
    $DomainAdminPassword
)


try {
    Start-Transcript -Path C:\cfn\log\Install-NetFramework.ps1.txt -Append
    $ErrorActionPreference = "Stop"	
    
    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)
    


    $InstallNetfwPs={
        $ErrorActionPreference = "Stop"
        $InstallPath = "C:\Exchangeinstall\NDP462-KB3151800-x86-x64-AllOS-ENU.exe"
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