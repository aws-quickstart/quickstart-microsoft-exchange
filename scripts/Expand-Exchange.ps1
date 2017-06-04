[CmdletBinding()]
param(

    [Parameter(Mandatory=$true)]
    [string]
    $ExchangeServerVersion

)

try {
	Start-Transcript -Path C:\cfn\log\Expand-Exchange.ps1.txt -Append
    $ErrorActionPreference = "Stop"
	
	if($ExchangeServerVersion -eq "2013") {
        Invoke-Command -ScriptBlock {Start-Process cmd.exe '/c c:\Exchangeinstall\Exchange2013-x64-cu15.exe /extract:c:\Exchangeinstall /passive' -NoNewWindow -Wait} 
    }
    elseif ($ExchangeServerVersion -eq "2016") {
        Invoke-Command -ScriptBlock {Start-Process cmd.exe '/c c:\Exchangeinstall\Exchange2016-x64.exe /extract:c:\Exchangeinstall /passive' -NoNewWindow -Wait} 		
    }
	
    
}
catch {
    $_ | Write-AWSQuickStartException
}
