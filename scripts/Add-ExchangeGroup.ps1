[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeGroupName,

    [Parameter(Mandatory=$True)]
    [string]
    $ServerName,

    [Parameter(Mandatory=$True)]
    [string]
    $LocalGroupName
)


try {
    Start-Transcript -Path C:\cfn\log\Add-ExchangeGroup.ps1.txt -Append
    $ErrorActionPreference = "Stop"
    
    $ExchangeGroup = [ADSI]"WinNT://$DomainNetBIOSName/$ExchangeGroupName,group" 
    $LocalGroup = [ADSI]"WinNT://$ServerName/$LocalGroupName,group" 
    $LocalGroup.PSBase.Invoke("Add",$ExchangeGroup.PSBase.Path) 

}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}