[CmdletBinding()]
param(
    [string]
    $ADAdminSecParam,

    [string]
    $DomainController
)

try {
    $AdminSecret = Get-SECSecretValue -SecretId $ADAdminSecParam -ErrorAction Stop | Select-Object -ExpandProperty 'SecretString'
    $ADAdminPassword = ConvertFrom-Json -InputObject $AdminSecret -ErrorAction Stop

    Write-Output 'Creating Credential Object for Administrator'
    $AdminUserName = $ADAdminPassword.UserName
    $AdminUserPW = ConvertTo-SecureString ($ADAdminPassword.Password) -AsPlainText -Force
    $cred = New-Object -TypeName 'System.Management.Automation.PSCredential' ($AdminUserName, $AdminUserPW)

    $sb = {
        repadmin /syncall /A /e /P
    }

    Write-Verbose "Invoking repadmin on $DomainController"
    Invoke-Command -ScriptBlock $sb -ComputerName $DomainController -Credential $cred -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}