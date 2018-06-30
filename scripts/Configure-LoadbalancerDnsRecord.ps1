[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true)]
    $ExchangeEndpointDNS,

    [string]
    [Parameter(Mandatory=$true)]
    $LoadBalancerRecord,

    [string]
    [Parameter(Mandatory=$true)]
    $DnsServer,
   
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
pin


try {
    Start-Transcript -Path C:\cfn\log\Configure-LoadbalancerDnsRecord.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)
    
    $LBecordPs={
        $ErrorActionPreference = "Stop"
        Add-DnsServerResourceRecordCName -Name $Using:ExchangeEndpointDNS -HostNameAlias $Using:LoadBalancerRecord -ZoneName $Using:DomainNetBIOSName
    }
    
    $Retries = 0
    $Installed = $false
    while (($Retries -lt 4) -and (!$Installed)) {
        try {

            Invoke-Command -Scriptblock $LBecordPs -ComputerName $DnsServer -Credential $DomainAdminCreds
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