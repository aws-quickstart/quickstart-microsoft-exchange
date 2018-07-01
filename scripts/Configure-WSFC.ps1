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

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode1NetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode2NetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode3NetBIOSName=$null,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode1PrivateIP2,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode2PrivateIP2,

    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeNode3PrivateIP2=$null,

    [Parameter(Mandatory=$false)]
    [string]
    $NetBIOSName

)
try {
    Start-Transcript -Path C:\cfn\log\Configure-Exchange.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

    $ConfigExchangePs={
        $nodes = $Using:ExchangeNode1NetBIOSName, $Using:ExchangeNode2NetBIOSName
        $addr =  $Using:ExchangeNode1PrivateIP2, $Using:ExchangeNode2PrivateIP2
        New-Cluster -Name Exchangeluster1 -Node $nodes -StaticAddress $addr
    }
    if ($ExchangeNode3NetBIOSName) {
        $ConfigExchangePs={
            $nodes = $Using:ExchangeNode1NetBIOSName, $Using:ExchangeNode2NetBIOSName, $Using:ExchangeNode3NetBIOSName
            $addr =  $Using:ExchangeNode1PrivateIP2, $Using:ExchangeNode2PrivateIP2, $Using:ExchangeNode3PrivateIP2
            New-Cluster -Name Exchangeluster1 -Node $nodes -StaticAddress $addr
        }
    }

    Invoke-Command -Authentication Credssp -Scriptblock $ConfigExchangePs -ComputerName $NetBIOSName -Credential $DomainAdminCreds
}
catch {
    $_ | Write-AWSQuickStartException
}
