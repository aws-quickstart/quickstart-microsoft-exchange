[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true, Position=0)]
    $InstallPath,

    [string]
    [Parameter(Mandatory=$true, Position=1)]
    $Username,

    [string]
    [Parameter(Mandatory=$true, Position=1)]
    $Password
)
try {
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

    Write-Verbose "Mapping Drive to installation path"
    New-PSDrive -Name Exch -PSProvider FileSystem -Root $InstallPath -Credential $cred

    Write-Verbose "Invoking Setup.exe..."
    Invoke-Expression "exch:\Setup.exe /mode:Install /role:EdgeTransport /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms" -ErrorAction Stop
}
catch {
    $_   
}