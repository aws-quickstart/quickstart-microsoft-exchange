[CmdletBinding()]
param()

try {
    Write-Verbose "Installing Exchange PreReq's"
    Install-WindowsFeature ADLDS -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}