[CmdletBinding()]
param(
    [string]
    [Parameter(Mandatory=$true, Position=0)]
    $DriveLetter
)
try {
    $ErrorActionPreference = "Stop"

    $driveLetter = Get-Volume | ? { $_.DriveLetter -notin @('','C') -and $_.FileSystemLabel -notlike "Temporary*" } | select -ExpandProperty DriveLetter
    if ($driveLetter.Count -lt 1) {
        throw "Volume not found."
    }
    elseif ($driveLetter.Count -gt 1) {
        throw "More than one volume found: $driveLetter"
    }
    Format-Volume -DriveLetter $driveLetter -FileSystem ntfs -NewFileSystemLabel 'Exchange Databases' -AllocationUnitSize 65536 -Confirm:$false -Force -ErrorAction stop
}
catch {
    $_ | Write-AWSQuickStartException
}