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
    $ExUserSecParam,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeNode1NetBIOSName,

    [Parameter(Mandatory=$true)]
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
    $FileServerNetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $DAGName="DAG"
)
try {
    Start-Transcript -Path C:\cfn\log\Configure-ExchangeDAG.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminPassword = ConvertFrom-Json -InputObject (Get-SECSecretValue -SecretId $ExUserSecParam).SecretString
    $DomainAdminCreds = (New-Object PSCredential($DomainAdminFullUser,(ConvertTo-SecureString $DomainAdminPassword.Password -AsPlainText -Force)))
    
    $ConfigDAG={
        $ErrorActionPreference = "Stop"

        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
        New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:FileServerNetBIOSName -WitnessDirectory C:\$Using:DAGName -DatabaseAvailabilityGroupIpAddresses '255.255.255.255'
        
        Start-Sleep -s 60

        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode1NetBIOSName
        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode2NetBIOSName

        # Manuall run
        #Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer $Using:ExchangeNode2NetBIOSName -ActivationPreference 2
        #Add-MailboxDatabaseCopy -Identity DB2 -MailboxServer $Using:ExchangeNode1NetBIOSName -ActivationPreference 2

        #There should also be a restart of the IS service (restart-service MSExchangeIS on each node)
        #Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"} | Update-MailboxDatabaseCopy -CatalogOnly

    }
    if ($ExchangeNode3NetBIOSName) {
        $ConfigDAG={
            $ErrorActionPreference = "Stop"
            
            Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
            New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:ExchangeNode3NetBIOSName -WitnessDirectory C:\$Using:DAGName
            
            Start-Sleep -s 60

            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode1NetBIOSName
            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode2NetBIOSName
        }
    }

 
   Invoke-Command -Authentication Credssp -Scriptblock $ConfigDAG -ComputerName localhost -Credential $DomainAdminCreds
}
catch {
    $_ | Write-AWSQuickStartException
}
