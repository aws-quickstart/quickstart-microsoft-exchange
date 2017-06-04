[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]$DomainNetBIOSName,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Mandatory=$true)]
    [string]$DomainAdminPassword,

    [Parameter(Mandatory=$true)]
    [string]$FileServerNetBIOSName

#    [Parameter(Mandatory=$true)]
#    [string]$SQLServiceAccount

)

Try{
    Start-Transcript -Path C:\cfn\log\Set-Folder-Permissions.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $DomainAdminFullUser = $DomainNetBIOSName + '\' + $DomainAdminUser
    $DomainAdminSecurePassword = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
    $DomainAdminCreds = New-Object System.Management.Automation.PSCredential($DomainAdminFullUser, $DomainAdminSecurePassword)

    $SetPermissions={
        $ErrorActionPreference = "Stop"
        $acl = Get-Acl C:\witness
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule( $Using:obj,'FullControl', 'ContainerInherit, ObjectInherit', 'None', 'Allow')
        $acl.AddAccessRule($rule)
        Set-Acl C:\witness $acl
    }

    $obj = $DomainNetBIOSName + '\WSFCluster1$'
    Invoke-Command -ScriptBlock $SetPermissions -ComputerName $FileServerNetBIOSName -Credential $DomainAdminCreds

    #$obj = $DomainNetBIOSName + '\' + $SQLServiceAccount
    #Invoke-Command -ScriptBlock $SetPermissions -ComputerName $FileServerNetBIOSName -Credential $DomainAdminCreds

}
Catch{
    $_ | Write-AWSQuickStartException
}
