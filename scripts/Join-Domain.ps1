[CmdletBinding()]
param(
    [string]
    $DomainName,

    [string]
    $ADAdminSecParam
)

try {
    $ErrorActionPreference = "Stop"

    $AdminSecret = Get-SECSecretValue -SecretId $ADAdminSecParam -ErrorAction Stop | Select-Object -ExpandProperty 'SecretString'
    $ADAdminPassword = ConvertFrom-Json -InputObject $AdminSecret -ErrorAction Stop

    Write-Output 'Creating Credential Object for Administrator'
    $AdminUserName = $DomainName + "\" + $ADAdminPassword.UserName
    $AdminUserPW = ConvertTo-SecureString ($ADAdminPassword.Password) -AsPlainText -Force

    $cred = New-Object -TypeName 'System.Management.Automation.PSCredential' ($AdminUserName, $AdminUserPW)

    Add-Computer -DomainName $DomainName -Credential $cred -ErrorAction Stop

    # Execute restart after script exit and allow time for external services
    $shutdown = Start-Process -FilePath "shutdown.exe" -ArgumentList @("/r", "/t 10") -Wait -NoNewWindow -PassThru
    if ($shutdown.ExitCode -ne 0) {
        throw "[ERROR] shutdown.exe exit code was not 0. It was actually $($shutdown.ExitCode)."
    }
}
catch {
    $_ | Write-AWSQuickStartException
}
