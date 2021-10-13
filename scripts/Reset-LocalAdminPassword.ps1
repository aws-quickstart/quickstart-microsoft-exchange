[CmdletBinding()]
param(
    [string]
    $ADAdminSecParam
)

try {
    $AdminSecret = Get-SECSecretValue -SecretId $ADAdminSecParam -ErrorAction Stop | Select-Object -ExpandProperty 'SecretString'
    $ADAdminPassword = ConvertFrom-Json -InputObject $AdminSecret -ErrorAction Stop

    Write-Output 'Creating Credential Object for Administrator'
    # $AdminUserName = $ADAdminPassword.UserName
    # $AdminUserPW = ConvertTo-SecureString ($ADAdminPassword.Password) -AsPlainText -Force 

    Write-Verbose "Resetting local admin password"
    ([adsi]"WinNT://$env:computername/Administrator,user").SetPassword($ADAdminPassword.Password)
}
catch {
    $_ | Write-AWSQuickStartException
}