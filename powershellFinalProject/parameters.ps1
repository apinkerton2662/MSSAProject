
<#
Parameters for Input
-----------------------
firstname	
lastname
upn	
department
streetaddress
city
mobilephone
password
officename
#>

function Set-Employees {
    param(
        [Parameter(Position = 0, mandatory = $true)]
        [string]$firstName,

        [Parameter(Position = 1, mandatory = $true)]
        [string]$lasttName,

        #convert into a function

        #[Parameter(Position = 2, mandatory = $true)]
        #[string]$upn,

        [Parameter(Position = 2, mandatory = $true)]
        [string]$department,

        [Parameter(Position = 3, mandatory = $true)]
        [string]$address,

        [Parameter(Position = 4, mandatory = $true)]
        [string]$city,

        [Parameter(Position = 5, mandatory = $true)]
        [string]$phone,

        [Parameter(Position = 6, mandatory = $true)]
        [string]$passWord,

        [Parameter(Position = 7, mandatory = $true)]
        [string]$officeName
    )

}

$paramValues = @{
    firstName = "Bob"
    lastName = "Marley"
    department = "IT"
    address = "101 three little birds lane"
    city = "London"
    phone = "0468813911"
    password = "kdlwi#@9kLPsl2()"
    officeName = "lon-100"
}

$paramObject = New-Object PSObject -property $paramValues

$csvFilePath = "C:\Program Files\Git Repositories\MSSAProject\powershellFinalProject"

$paramObject | Export-Csv -Path $csvFilePath -append -NoTypeInformation







