[CmdletBinding()]
param()

try {
    Write-Verbose "Invoking c:\cfn\downloads\UcmaRuntimeSetup.exe"
    Invoke-Expression "c:\cfn\downloads\UcmaRuntimeSetup.exe /passive /norestart" -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}