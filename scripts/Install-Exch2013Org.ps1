[CmdletBinding()]
param(
    $InstallPath
)
try {
    $InstallPath = Join-Path -Path $InstallPath -ChildPath Setup.exe
    Invoke-Expression "$InstallPath /PrepareAD /OrganizationName:Exchange /IAcceptExchangeServerLicenseTerms"
}
catch {
    $_ | Write-AWSQuickStartException    
}