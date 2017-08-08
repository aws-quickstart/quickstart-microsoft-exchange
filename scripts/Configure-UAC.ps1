[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true)]
    $Status
)


try {
    Start-Transcript -Path C:\cfn\log\Configure-UAC.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    if($Status -eq "Disable") {
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "0"
    }

    elseif($Status -eq "Enable") {
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value "1"
    }
}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}