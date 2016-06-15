[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true, Position=0)]
    $InstallPath,

    [int]
    [Parameter(Mandatory=$false, Position=1)]
    $Server = 1
)
try {
    $InstallPath = Join-Path -Path $InstallPath -ChildPath Setup.exe
    Invoke-Expression "$InstallPath /mode:Install /role:ClientAccess,Mailbox /MdbName:DB$Server /DbFilePath:'D:\Databases\DB$Server\DB$Server.edb' /LogFolderPath:'D:\Databases\DB$Server' /InstallWindowsComponents /IAcceptExchangeServerLicenseTerms" -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException    
}