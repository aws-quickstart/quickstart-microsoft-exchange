param(
    # [Parameter(Mandatory=$true)]
    # [string]
    # $ExchangeServerVersion,

    [Parameter(Mandatory=$true)]
    [string]
    $SecurityPatchDownloadLink
)


try {
        $ErrorActionPreference = "Stop"
    $filename = $SecurityPatchDownloadLink.Substring($SecurityPatchDownloadLink.LastIndexOf("/") + 1)

    $InstallPath = "C:\Exchangeinstall" + "\" + $filename
    $InstallArgs = "/silent"

    Start-Process $InstallPath -args $InstallArgs -Wait -ErrorAction Stop -RedirectStandardOutput "C:\cfn\log\SecurityUpdate.txt" -RedirectStandardError "C:\cfn\log\SecurityUpdate.txt"

    # if($ExchangeServerVersion -eq "2016") {
    #     $isoPath = $Path + "\" + $filename

    # }
    # elseif ($ExchangeServerVersion -eq "2019") {
    #     $isoPath = $Path + "\" + $filename

    # }
}
catch {
   # $_ | Write-AWSQuickStartException
}