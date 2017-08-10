[CmdletBinding()]
param(
    [string]
    $ComputerName,

    [string]
    $UserName,

    [string]
    $Password,

    [string]
    $FolderName,

    [string]
    $ShareName
)

try {
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName,$pass
    
    $sb = { param($path,$share) New-SmbShare -Name $share -Path $path -FullAccess everyone }
        
    Invoke-Command -ScriptBlock $sb -ArgumentList $FolderName,$ShareName -ComputerName $ComputerName -Credential $cred -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}