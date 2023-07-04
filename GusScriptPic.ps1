# VHD Path
$vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\"

# Create Server Names
[System.Collections.ArrayList]$serverList = @("KEMP-RTR1", "KEMP-DC1", "DURANT-RTR1","DURANT-DC1","PAYTON-RTR1","PAYTON-DC1")
# Use Servername array to make respective VHD names
[System.Collections.ArrayList]$vhdList = 

foreach ($name in $serverList) {
  $test = $name+".vhd"
  $vhdList + $test
}

# Create VHDs
$vhdxPath = "C:\Program Files\Microsoft Learning\Base\Base22A-WS22-2348.vhd"

foreach ($vhdName in $vhdList) {
  $vhdPathInternal = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\$vhdName"

  New-VHD -ParentPath $vhdxPath -path $vhdPathInternal
}


[System.Collections.ArrayList]$adapters = @("Seattle","Dallas","Capital","SEAtoDAL","SEAtoCAP","SEAtoINET")
$counter = 0
foreach ($vhdName in $vhdList) {
  $VM = @{
    Name = $vhdName
    MemoryStartupBytes = 2147483648
    Generation = 1
    BootDevice = "VHD"
    VHDPath = $vhdpath+"\"+ $vhdlist[$counter]
    Path = "C:\Desktop"
  }
  New-VM @VM
  $counter += 1
}