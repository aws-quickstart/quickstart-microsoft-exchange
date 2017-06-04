param(

	[Parameter(Mandatory=$True)]
	[string]
	$ServerName,

	[Parameter(Mandatory=$True)]
	[string]
	$GroupName,

	[Parameter(Mandatory=$True)]
	[string]
	$DomainNetBIOSName,

	[Parameter(Mandatory=$True)]
	[string]
	$UserName

)

try {
    Start-Transcript -Path C:\cfn\log\AddUserToGroup.ps1.txt -Append

    $ErrorActionPreference = "Stop"

	$de = [ADSI]"WinNT://$ServerName/$GroupName,group"

	$UserPath = ([ADSI]"WinNT://$DomainNetBIOSName/$UserName").path
	$Retries = 0
	while (($Retries -lt 8) -and (!$UserPath)) {
		$Retries++
		Start-Sleep -Seconds ($Retries * 60)
		$UserPath = ([ADSI]"WinNT://$DomainNetBIOSName/$UserName").path
	}

	$de.psbase.Invoke("Add",$UserPath)

}
catch {
    Write-Verbose "$($_.exception.message)@ $(Get-Date)"
    $_ | Write-AWSQuickStartException
}
