<# This script creates virtual machines and configures network adapters #>
# Set VHD Path
$vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks"

# Set Parent Path
$vhdParentPath = "C:\Program Files\Microsoft Learning\Base\Base22A-WS22-2348.vhd"

# Create list of desired computer names
[System.Collections.ArrayList]$serverList = @("KEMP-RTR1","KEMP-DC1","DURANT-RTR1","DURANT-DC1","PAYTON-RTR1","PAYTON-DC1")

# Create a list of desired switch names
[System.Collections.ArrayList]$switchList = @("SeattleSwitch","CapitalSwitch","DallasSwitch","SEAtoDAL","SEAtoCAP","SEAtoINET")

# Use $serverList to create VHD names
[System.Collections.ArrayList]$vhdList = forEach ($server in $serverList) {
  $vhdList + ($server + ".vhd")
}

# Create VHDs
foreach ($vhd in $vhdList) {
  $vhdPathInternal = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\$vhd"
  New-VHD -ParentPath $vhdParentPath -path $vhdPathInternal
}

# Create VMs
foreach ($vhd in $vhdList) {
  $VM = @{
  Name = $vhd
  MemoryStartupBytes = 2147483648
  Generation = 1
  BootDevice = "VHD"
  VHDPath = $vhdPath + "\" + $vhd
  Path = "C:\Desktop"
  }
  New-VM @VM
}

# Create Virtual Switches
foreach ($switch in $switchList) {
  New-VMSwitch -Name $switch -SwitchType Private
}


# Add locational switches to both DC and RTR for each geographic location
foreach ($vhd in $vhdList) {
  if($vhd -like "KEMP*") {
    Connect-VMNetworkAdapter -VMName $vhd -SwitchName SeattleSwitch
  } elseif ($vhd -like "DURANT*") {
    Connect-VMNetworkAdapter -VMName $vhd -SwitchName DallasSwitch
  } elseif ($vhd -like "PAYTON*") {
    Connect-VMNetworkAdapter -VMName $vhd -SwitchName CapitalSwitch
  }
}

# Add the remaining switches to the appropriate routers
foreach ($vhd in $vhdList) {
  if($vhd -eq "KEMP-RTR1.vhd") {
    [System.Collections.ArrayList]$seaSwitches = @("SEAtoINET","SEAtoDAL","SEAtoCAP")
    foreach ($seaSwitch in $seaSwitches) {
      Add-VMNetworkAdapter -VMName $vhd -SwitchName $seaSwitch
      Connect-VMNetworkAdapter -VMName $vhd -SwitchName $seaSwitch
    }
  } elseif ($vhd -eq "DURANT-RTR1.vhd") {
    Add-VMNetworkAdapter -VMName $vhd -Name SEAtoDAL -SwitchName SEAtoDAL
    Connect-VMNetworkAdapter -VMName $vhd -SwitchName SEAtoDAL
  } elseif ($vhd -eq "PAYTON-RTR1.vhd") {
    Add-VMNetworkAdapter -VMName $vhd -SwitchName SEAtoCAP
    Connect-VMNetworkAdapter -VMName $vhd -SwitchName SEAtoCAP
  } 
}