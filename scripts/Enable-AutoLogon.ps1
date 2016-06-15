[CmdletBinding()]
param(
    [string]
    $UserName,

    [String]
    $Password,

    [String]
    $StartupScript
)

try {
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoAdminLogon -Value 1
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultUserName -Value $UserName
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name DefaultPassword -Value $Password
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce -Name Install -Value $StartupScript
}
catch {
    $_ | Write-AWSQuickStartException
}