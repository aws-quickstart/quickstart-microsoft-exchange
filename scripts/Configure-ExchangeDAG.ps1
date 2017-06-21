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
    $WSFCNode1NetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCNode2NetBIOSName,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCNode3NetBIOSName=$null,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCNode1PrivateIP2,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCNode2PrivateIP2,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCNode3PrivateIP2=$null,

    [Parameter(Mandatory=$false)]
    [string]
    $WSFCFileServerNetBIOSName,

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
        $nodes = $Using:WSFCNode1NetBIOSName, $Using:WSFCNode2NetBIOSName
         #$addr =  $Using:WSFCNode1PrivateIP2, $Using:WSFCNode2PrivateIP2, $Using:WSFCNode3PrivateIP2
            
        Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
        New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:WSFCFileServerNetBIOSName -WitnessDirectory C:\$Using:DAGName 
       
        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:WSFCNode1NetBIOSName
        Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:WSFCNode2NetBIOSName

        Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer $Using:WSFCNode1NetBIOSName -ActivationPreference 2
        Add-MailboxDatabaseCopy -Identity DB2 -MailboxServer $Using:WSFCNode2NetBIOSName -ActivationPreference 2

        #There should also be a restart of the IS service (restart-service MSExchangeIS on each node)
        #Get-MailboxDatabaseCopyStatus * | where {$_.ContentIndexState -eq "Failed"} | Update-MailboxDatabaseCopy -CatalogOnly

    }
    if ($WSFCNode3NetBIOSName) {
        $ConfigDAG={
            $nodes = $Using:WSFCNode1NetBIOSName, $Using:WSFCNode2NetBIOSName, $Using:WSFCNode3NetBIOSName
            #$addr =  $Using:WSFCNode1PrivateIP2, $Using:WSFCNode2PrivateIP2, $Using:WSFCNode3PrivateIP2
            
            Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
            New-DatabaseAvailabilityGroup -Name $Using:DAGName -WitnessServer $Using:WSFCFileServerNetBIOSName -WitnessDirectory C:\$Using:DAGName 
            
            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:WSFCNode1NetBIOSName
            Add-DatabaseAvailabilityGroupServer -Identity $Using:DAGName -MailboxServer $Using:WSFCNode2NetBIOSName

            Add-MailboxDatabaseCopy -Identity DB1 -MailboxServer $Using:WSFCNode1NetBIOSName -ActivationPreference 2
            Add-MailboxDatabaseCopy -Identity DB2 -MailboxServer $Using:WSFCNode2NetBIOSName -ActivationPreference 2

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
