[CmdletBinding()]
param(
    [Parameter(Position=0,Mandatory=$true)]
    [string]$DomainAdminUser,

    [Parameter(Position=1,Mandatory=$true)]
    [string]$DomainAdminPassword,

    [Parameter(Position=2,Mandatory=$true)]
    [string]$DomainController,

	[Parameter(Position=3, Mandatory=$false)]
	[System.Int32]
	$count = 1,

    [Parameter(Position=4,Mandatory=$true)]
    [string]$BucketName,

    [Parameter(Position=5,Mandatory=$false)]
    [string]$Prefix,

	[Parameter(Position=6, Mandatory=$false)]
	[System.String]
	$password = [System.Web.Security.Membership]::GeneratePassword(10,2),
		
	[Parameter(Position=7, Mandatory=$false)]
	[System.String]
	$UpnSuffix = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().RootDomain.Name,

	[Parameter(Position=8, Mandatory=$false)]
	[System.String]
	$Description = "",	
	
	[Parameter(Position=9, Mandatory=$false)]
	[System.String]
	$OrganizationalUnit = ("CN=users," + ([ADSI]"LDAP://RootDSE").defaultNamingContext)
)

    try {
            $ErrorActionPreference = "Stop"
            Start-Transcript -Path C:\cfn\log\$($MyInvocation.MyCommand.Name).log -Append
            Import-Module AWSPowerShell
            Copy-S3Object -BucketName $BucketName -Key $Prefix -LocalFile "C:\cfn\scripts\users.csv"
            Get-Content "C:\cfn\scripts\users.csv" | Out-File "C:\cfn\scripts\users2.csv"
            $users = Import-Csv -Path "C:\cfn\scripts\users2.csv"
            $userpwd = ConvertTo-SecureString -AsPlainText $password -Force
                1..$count | %{                      
                    $r1 = Get-Random -Min 1 -Maximum 1000
                    $r2 = Get-Random -Min 1 -Maximum 1000
                    $firstname = $users[$r1].firstname
                    $lastname = $users[$r2].lastname
                    $upn = "$($firstname[0])$lastname@$UpnSuffix".ToLower()
                    $name = "$firstname $lastname"
                    $alias = "$($firstname[0])$lastname".ToLower()
                            
                    New-ADUser -Server $DomainController -Credential (New-Object System.Management.Automation.PSCredential($DomainAdminUser,(ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force))) -Name $name `
                    -GivenName $firstname `
                    -Surname $lastname `
                    -SamAccountName $alias `
                    -DisplayName $name `
                    -AccountPassword $userpwd `
                    -PassThru `
                    -Enabled $true `
                    -UserPrincipalName $upn `
                    -Description $Description `
                    -EA 0
                    echo "Done"
                           
                }                
        }
    catch {
        $_ | Write-AWSQuickStartException
    }