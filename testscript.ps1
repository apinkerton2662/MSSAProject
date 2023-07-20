<# This script creates virtual machines and configures network adapters #>
# Set VHD Path
New-Item -Path C:\Users\Public\Documents\ -name "Hyper-V" -ItemType Directory
New-Item -Path C:\Users\Public\Documents\Hyper-V\ -Name "Virtual Hard Disks" -ItemType Directory
$vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\"

# Set VM Path
$vmPath = "C:\Users\Public\Documments\Hyper-V\"

# Set Parent Path
# Not Required $vhdParentPath = ****

# Create list of desired computer names
$servers = "HQ-RTR1","HQ-DC1"

# Create a list of desired switch names
$switches = "HQtoATL","HQDCSwitch","HQUserSwitch"

# Use $serverList to create VHD names
$vhds = foreach ($server in $servers) {
  $vhds + ($server + ".vhd")
}

# Create VHDs
foreach ($vhd in $vhds) {
  $vhdPathInternal = "C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\$vhd"
  New-VHD -ParentPath $vhdParentPath -path $vhdPathInternal -Differencing 
}

# Create VMs
foreach ($server in $servers) {
  $VM = @{
  Name = $server
  MemoryStartupBytes = 2147483648
  Generation = 1
  BootDevice = "VHD"
  VHDPath = $vhdPath + "\" + $vhd
  Path = "C:\Desktop"
  }
  New-VM @VM
}

# Create Virtual Switches
foreach ($switch in $switches) {
  New-VMSwitch -Name $switch -SwitchType Private
}


# Add locational switches to both DC and RTR for each geographic location
foreach ($server in $servers) {
  if($server -like "KEMP*") {
    Get-VMNetworkAdapter -VMName $server | Connect-vmnetworkadapter -SwitchName SeattleSwitch
  } elseif ($server -like "DURANT*") {
    Get-VMNetworkAdapter -VMName $server | Connect-vmnetworkadapter -SwitchName DallasSwitch
  } elseif ($server -like "PAYTON*") {
    Get-VMNetworkAdapter -VMName $server | Connect-VMNetworkAdapter -SwitchName CapitalSwitch
  }
}

# Add network adapters to routers and connect to switches
foreach ($server in $servers) {
  if($server -eq "KEMP-RTR1") {
    $seaSwitches = "SEAtoINET","SEAtoDAL","SEAtoCAP"
    foreach ($seaSwitch in $seaSwitches) {
      Add-VMNetworkAdapter -VMName $server -Name "$seaSwitch" -SwitchName $seaSwitch
    }
  } elseif ($server -eq "DURANT-RTR1") {
    Add-VMNetworkAdapter -VMname $server -Name SEAtoDAL -switchname SEAtoDAL
  } elseif ($server -eq "PAYTON-RTR1") {
    Add-VMNetworkAdapter -VMName $server -name SEAtoCAP -SwitchName SEAtoCAP
  } 
}

<# TESTED AND IT WORKS! #>