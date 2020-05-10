[CmdletBinding()]

param(

    [Parameter(Mandatory=$false)]
    [string]
    $EnableReFSVolumes

)

try {
    Start-Transcript -Path C:\cfn\log\Initialize-Disks.ps1.txt -Append
    $ErrorActionPreference = "Stop"

    $newdisk = get-disk | where partitionstyle -eq 'raw'

    foreach ($d in $newdisk){
        $disknum = $d.Number
        Initialize-Disk -Number $disknum -PartitionStyle GPT
        Set-Disk -Number $disknum -IsReadOnly $False
        $partition = New-Partition -DiskNumber $disknum -UseMaximumSize -AssignDriveLetter

        if($EnableReFSVolumes -eq $true) {
        Format-Volume -Partition $partition -FileSystem ReFS -SetIntegrityStreams $false -Confirm:$false
        }

        elseif($EnableReFSVolumes -eq $false) {
        Format-Volume -Partition $partition -FileSystem NTFS -Confirm:$false
        }
    }
}
catch {
    $_ | Write-AWSQuickStartException
}