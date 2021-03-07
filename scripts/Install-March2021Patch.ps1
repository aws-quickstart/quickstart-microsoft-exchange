param(
    [Parameter(Mandatory=$false)]
    [string]
    $ExchangeServerVersion = "2016"
)

if($ExchangeServerVersion -eq "2016") {
    Invoke-WebRequest -Uri https://aws-quickstart.s3.amazonaws.com/static/Patch2016.msp -OutFile c:\cfn\Patch.msp
}
elseif ($ExchangeServerVersion -eq "2019") {
    Invoke-WebRequest -Uri https://aws-quickstart.s3.amazonaws.com/static/Patch2019.msp -OutFile c:\cfn\Patch.msp
}

msiexec /update c:\cfn\Patch.msp /quiet