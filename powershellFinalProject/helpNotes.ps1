<#
.SYNOPSIS
This script imports user data from a CSV file and performs Active Directory actions.

 

.DESCRIPTION
This script reads user data from a CSV file and performs actions like creating or updating user accounts in Active Directory.

 

.PARAMETER CsvFilePath
Path to the CSV file containing user data.
-CsvFilePath: Path to the CSV file.

 

.EXAMPLE
Example usage of the script with explanations.
PS> .\Import-ADUsersFromCSV.ps1 -CsvFilePath "C:\Path\To\Users.csv"

 

.NOTES
Author: Your Name
Date: Date created or last modified
Version: Semantic version number
#>

 

# Import the Active Directory module
Import-Module ActiveDirectory

 

# Read CSV file
$csvFilePath = "C:\Path\To\Users.csv"
$csvData = Import-Csv -Path $csvFilePath

 

# Process each row in the CSV
foreach ($row in $csvData) {
    $username = $row.Username
    $firstName = $row.FirstName
    $lastName = $row.LastName
    $email = $row.Email

 

    # Check if the user already exists in AD
    $existingUser = Get-ADUser -Filter {SamAccountName -eq $username}

 

    if ($existingUser) {
        # Update existing user properties
        Set-ADUser -Identity $username -FirstName $firstName -LastName $lastName -EmailAddress $email
        Write-Host "Updated user: $username"
    } else {
        # Create new user account
        $password = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
        New-ADUser -SamAccountName $username -UserPrincipalName "$username@example.com" -GivenName $firstName -Surname $lastName -EmailAddress $email -AccountPassword $password -Enabled $true
        Write-Host "Created user: $username"
    }
}

 

# Error handling (if applicable)
Trap {
    Write-Host "An error occurred: $_"
    # Additional error handling actions
}

 

# Script cleanup and finalization
# Any cleanup actions or resource disposal code goes here