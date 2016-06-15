[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true, Position=0)]
    $DriveLetter
)
try {
    Format-Volume -DriveLetter d -FileSystem ntfs -NewFileSystemLabel 'Exchange Databases' -AllocationUnitSize 65536 -Confirm:$false -Force -ErrorAction stop
}
catch {
    $_ | Write-AWSQuickStartException    
}