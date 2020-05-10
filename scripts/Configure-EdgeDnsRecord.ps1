[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true)]
    $EdgeNodeNetBIOSName,

    [string]
    [Parameter(Mandatory=$true)]
    $EdgeNodePrivateIP,

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
    $ExUserSecParam
)



try {
    Start-Transcript -Path C:\cfn\log\Configure-EdgeDNSRecord.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = ConvertFrom-Json -InputObject (Get-SECSecretValue -SecretId $ExUserSecParam).SecretString
    $DomainAdminCreds = (New-Object PSCredential($DomainAdminFullUser,(ConvertTo-SecureString $DomainAdminPassword.Password -AsPlainText -Force)))

    $EdgeRecordPs={
        $ErrorActionPreference = "Stop"
        Add-DnsServerResourceRecordA -Name $Using:EdgeNodeNetBIOSName -IPv4Address $Using:EdgeNodePrivateIP -ZoneName $Using:DomainNetBIOSName
    }

    $Retries = 0
    $Installed = $false
    while (($Retries -lt 4) -and (!$Installed)) {
        try {

            Invoke-Command -Scriptblock $EdgeRecordPs -ComputerName $DnsServer -Credential $DomainAdminCreds
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