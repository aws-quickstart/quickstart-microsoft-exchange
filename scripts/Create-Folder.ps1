[CmdletBinding()]
param(
    [string]
    $ComputerName,

    [string]
    $UserName,

    [string]
    $Password,

    [string]
    $FolderName
)

try {
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName,$pass
    
    $sb = { param($path) New-Item -ItemType directory -Path c:\ -Name $path }
        
    Invoke-Command -ScriptBlock $sb -ArgumentList $FolderName -ComputerName $ComputerName -Credential $cred -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}