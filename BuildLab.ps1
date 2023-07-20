# This script builds a test lab in Hyper-V for the MSSA Project

Clear-Host

# Configure credentials
$Cred1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'Administrator',('Pa55w.rd' | ConvertTo-SecureString -AsPlainText -Force)
$Cred2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'DiscGolfMedia\Administrator',('Pa55w.rd' | ConvertTo-SecureString -AsPlainText -Force)

# Create new shell
$wshell = New-Object -ComObject Wscript.Shell

Write-Host "Creating Virtual Switches"

# Creates two switches.  **MAY CHANGE TO NAMES**
New-VMSwitch -Name 'Private Network' -SwitchType Private
New-VMSwitch -Name 'Private Network 2' -SwitchType Private

# Grab Switch names
$vmswitch1 = Get-VMSwitch -Name 'Private Network' | Select-Object -ExpandProperty Name | Out-Null
$vmswitch2 = Get-VMSwitch -Name 'Private Network2' | Select-Object -ExpandProperty Name | Out-Null

Clear-Host

Write-Host "Creating Virtual Machines"

# Set Path to ISOs
$ISOPath = Get-Item -Path 'C:\ISOs\WS*.ISO' | Select-Object -Property Name
$ISOPath2 = Get-Item -Path 'C:\ISOs\Win1*.ISO' | Select-Object -Property Name

# Create Directory for VMs, if needed
Set-Location 'C:\'
New-Item -ItemType Directory -Name 'HVVM' -ErrorAction SilentlyContinue

$Path = "C:\HVVM\"

# Create RTR
New-VM -Name 'HQ-RTR1' -Path ($Path + 'HQ-RTR1') -MemoryStartupBytes 2GB -NewVHDPath ($Path + 'HQ-RTR1\Virtual Disks\HQ-RTR1.vhdx') -NewVHDSizeBytes 20GB -SwitchName 'Private Network'



# Configure processor and add cores
Invoke-Command -VMName HQ-RTR1 -Credential $Cred1 -ScriptBlock {Set-VMProcessor -Count 2} -ErrorAction SilentlyContinue

# Configure VM to boot from ISO
# Add DVD Drive
Invoke-Command -VMName HQ-RTR1 -Credential $Cred1 -ScriptBlock {Add-VMDVDDrive -Path "$ISOPath.FullName"} -ErrorAction SilentlyContinue

Clear-Host

# Start VMs
Write-Host "Starting VMs"
Start-VM -Name 'HQ-RTR1'

While((Get-VM -Name 'HQ-RTR1').HeartBeat -ne 'OkApplicationsHealthy') {
  Start-Sleep -Seconds 1
}



# Change Computer Name
Invoke-Command -VMName HQ-RTR1 -Credential $Cred1 -ScriptBlock {Rename-Computer -NewName HQ-RTR1 -Force -Restart}

# Set IP Information





$labName = "DGMLab"

#create an empty lab template and define where the lab XML 
