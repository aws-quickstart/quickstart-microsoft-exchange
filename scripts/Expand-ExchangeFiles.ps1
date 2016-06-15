[CmdletBinding()]
param(
    [string]
    $ComputerName,

    [string]
    $UserName,

    [string]
    $Password
)

try {
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName,$pass
        
    Invoke-Command -ScriptBlock {Start-Process cmd.exe '/c c:\exchinstall\Exchange2013-x64-cu7.exe /extract:c:\exchinstall /passive' -NoNewWindow -Wait} -ComputerName $ComputerName -Credential $cred
}
catch {
    $_ | Write-AWSQuickStartException
}