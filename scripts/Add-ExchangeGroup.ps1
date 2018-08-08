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

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeGroupName="Exchange Trusted Subsystem",

    [Parameter(Mandatory=$True)]
    [string]
    $ServerName,

    [Parameter(Mandatory=$false)]
    [string]
    $LocalGroupName="Administrators"   
)


try {
    Start-Transcript -Path C:\cfn\log\Add-ExchangeGroup.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = (Get-SSMParameterValue -Names $SSMParamName -WithDecryption $True).Parameters[0].Value
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)
    
    $ExchangeGroupPS={
        $ErrorActionPreference = "Stop"
        $ExchangeGroup = [ADSI]"WinNT://$Using:DomainNetBIOSName/$Using:ExchangeGroupName,group" 
        $LocalGroup = [ADSI]"WinNT://$Using:ServerName/$Using:LocalGroupName,group" 
        $LocalGroup.PSBase.Invoke("Add",$ExchangeGroup.PSBase.Path) 
    }
    
    $Retries = 0
    $Installed = $false
    while (($Retries -lt 4) -and (!$Installed)) {
        try {

            Invoke-Command -Scriptblock $ExchangeGroupPS -ComputerName $ServerName -Credential $DomainAdminCreds
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