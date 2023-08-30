$csvFilePath = "C:\Users\gusta\Downloads\NewHires.csv"

$csvFile = Import-Csv -path $csvFilePath -Delimiter ","

$departments = $csvFile | Select-Object -Property department
$departmentArray = $departments.department

$orgUnits = Get-ADOrganizationalUnit | Select-Object -property Name
$orgUnitsArray = $orgUnits.Name

foreach ($department in $departmentArray){
    foreach($name in $orgUnits){
        if($departments.department -ne $orgUnits.name){
            New-ADOrganizationalUnit -name $department
        }
    }
}