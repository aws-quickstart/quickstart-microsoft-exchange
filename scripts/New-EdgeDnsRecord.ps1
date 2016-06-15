[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true, Position=0)]
    $Name,

    [string]
    [Parameter(Mandatory=$true, Position=1)]
    $ZoneName,

    [string]
    [Parameter(Mandatory=$true, Position=2)]
    $DnsServer,

    [string]
    [Parameter(Mandatory=$true, Position=3)]
    $Username,

    [string]
    [Parameter(Mandatory=$true, Position=4)]
    $Password
)
try {
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

    Write-Verbose "Retrieving IP configuration"
    $netip = Get-NetIPConfiguration
    $ipconfig = Get-NetIPAddress | ?{$_.IpAddress -eq $netip.IPv4Address.IpAddress}

    $IPv4Address = $ipconfig.IPAddress

    $sb = { param($Name, $IPv4Address, $ZoneName) Add-DnsServerResourceRecordA -Name $Name -IPv4Address $IPv4Address -ZoneName $ZoneName}

    Write-Verbose "Creating DNS A Record for $Name.$ZoneName"
    Write-Verbose "Invoking Add-DnsServerResourceRecordA on $DnsServer..."
    Invoke-Command $sb -ArgumentList $Name, $IPv4Address, $ZoneName -ComputerName $DnsServer -Credential $cred -ErrorAction Stop
}
catch {
    $_ | Write-AWSQuickStartException
}