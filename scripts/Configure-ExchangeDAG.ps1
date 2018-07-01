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
    $FileServerNetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $NetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion,

    [Parameter(Mandatory=$true)]
    [string]
    $DAGName
)
try {
    Start-Transcript -Path C:\cfn\log\Configure-ExchangeDAG.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

    $ConfigDAG={
        $ErrorActionPreference = "Stop"
        $nodes = $Using:ExchangeNode1NetBIOSName, $Using:ExchangeNode2NetBIOSName
         #$addr =  $Using:ExchangeNode1PrivateIP2, $Using:ExchangeNode2PrivateIP2, $Using:ExchangeNode3PrivateIP2
            
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
        New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:FileServerNetBIOSName -WitnessDirectory C:\$Using:DAGName 
       
        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode1NetBIOSName
        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode2NetBIOSName

        Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer $Using:ExchangeNode2NetBIOSName -ActivationPreference 2
        Add-MailboxDatabaseCopy -Identity DB2 -MailboxServer $Using:ExchangeNode1NetBIOSName -ActivationPreference 2

        #There should also be a restart of the IS service (restart-service MSExchangeIS on each node)
        #Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"} | Update-MailboxDatabaseCopy -CatalogOnly

    }
    if ($ExchangeNode3NetBIOSName) {
        $ConfigDAG={
            $ErrorActionPreference = "Stop"
            $nodes = $Using:ExchangeNode1NetBIOSName, $Using:ExchangeNode2NetBIOSName, $Using:ExchangeNode3NetBIOSName
            #$addr =  $Using:ExchangeNode1PrivateIP2, $Using:ExchangeNode2PrivateIP2, $Using:ExchangeNode3PrivateIP2
            
            Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
            New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:FileServerNetBIOSName -WitnessDirectory C:\$Using:DAGName 
            
            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode1NetBIOSName
            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:ExchangeNode2NetBIOSName

            Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer $Using:ExchangeNode2NetBIOSName -ActivationPreference 2
            Add-MailboxDatabaseCopy -Identity DB2 -MailboxServer $Using:ExchangeNode1NetBIOSName -ActivationPreference 2

            #There should also be a restart of the IS service (restart-service MSExchangeIS on each node)
            #Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"} | Update-MailboxDatabaseCopy -CatalogOnly
        }
    }

   # Invoke-Command -Authentication Credssp -Scriptblock $ConfigDAG -ComputerName $NetBIOSName -Credential $DomainAdminCreds
   Invoke-Command -Authentication Credssp -Scriptblock $ConfigDAG -ComputerName localhost -Credential $DomainAdminCreds
}
catch {
    $_ | Write-AWSQuickStartException
}
