[CmdletBinding()]

param(

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion

)

try {
    Start-Transcript -Path C:\cfn\log\Install-ExchPrerequisites.ps1.txt -Append
    $ErrorActionPreference = "Stop"
	
	$Retries = 0
    $Installed = $false
	
	while (($Retries -lt 4) -and (!$Installed)) {
		if($ExchangeServerVersion -eq "2013") {	
			try {
			Install-WindowsFeature Server-Media-Foundation
			Install-WindowsFeature RSAT-ADDS,AS-HTTP-Activation, Desktop-Experience, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation -ErrorAction Stop
			$Installed = $true
			}
			catch {
				$Exception = $_
				$Retries++
				if ($Retries -lt 4) {
					Start-Sleep ($Retries * 60)
				}
			}
		}
	
	elseif ($ExchangeServerVersion -eq "2016") {
		try {
		Install-WindowsFeature Server-Media-Foundation		
		Install-WindowsFeature NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, Web-Mgmt-Console, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS -ErrorAction Stop
		$Installed = $true
		}
		catch {
            $Exception = $_
            $Retries++
            if ($Retries -lt 4) {
                Start-Sleep ($Retries * 60)
            }
        }
	}
	
	
    }
	
	if (!$Installed) {
          throw $Exception
	}
	
}
catch {
    $_ | Write-AWSQuickStartException
}