function Import-VMAdvanced {

    <#
    .SYNOPSIS
    Import Vitual Machine into Hyper-V host with extended functionality

    .DESCRIPTION
    Imports Virtual Machine from template, Renames the imported vm inside Hyper-V host, Keeps convenient directory structure, Assigns Vlan to one or more network adapters

    .EXAMPLE
    Import-VMAdvanced

    .NOTES
    Created by Jakub Petrovic
    https://github.com/petrojak
    https://www.linkedin.com/in/jakub-petrovič-32904a10b/
    
    #>
}

#Use this script at your own risk
#This script is made only for Hyper-V 2016 and later

#TODO input arguments VMNAME, VLAN, DESTINATION, TEMPLATE
#TODO Refactor, create functions, clean up code
#TODO Dynamically select vm store

#Define VM store and destination for the new VMs 
$vmStorePath = "D:\Hyper-V exports\"
$destinationPath = 'F:\VirtualMachines\'

#Lists available VMs to import/clone
Write-Host ("VMs available in " + $vmStorePath) -ForegroundColor Green

$templates = Get-ChildItem -Path $vmStorePath
$index = 1
foreach($template in $templates){
    Write-Output ("$index" + " - " + "$template.Name")
    $index++
}

#Read host for imput - select which VM to clone
Write-Host 'Select VM to import/clone:' -ForegroundColor Green
$selectedIndex = Read-Host

#Search for VCMX file in selected directory
#TEST Hyper-V 2012 R2 compatibility (xml files instead of vmcx)
$configFolderPath = $vmStorePath + $templates[$selectedIndex-1].Name + '\Virtual Machines\'

if( -NOT ($configFilePath = Get-Childitem -Path $configFolderPath -Recurse -Include '*.vmcx')){
    $configFilePath = Get-Childitem -Path $configFolderPath -Recurse -Include '*.xml'
}

#Get VM name and set the detination path + filter input to ensure desired folder structure
Write-Host 'Insert name for the new VM:' -ForegroundColor Green
$newVmName = Read-Host
if($newVmName -notlike "*/*" -and $newVmName -notlike "*\*" ){
    $destinationPath += $newVmName
}else{
    Throw "VM name cannot contain / or \"
}

#Checks if destination path is available
#TODO promp if folder exists but is empty
if(Test-Path -Path $destinationPath){
    Throw ("Directory " + $destinationPath + " already exists")
}

#import virtual machine
Write-Host ("`nImporting VM " + $newVmName + " please wait...") -ForegroundColor Yellow
Import-VM -Path $configFilePath `
    -copy  `
    -GenerateNewId `
    -SnapshotFilePath  ($destinationPath + '\Snapshots') `
    -VhdDestinationPath ($destinationPath + '\Virtual Hard Disks') `
    -VirtualMachinePath ($destinationPath) `
    | out-null

#Get all vms and search for the newly created one 
$virtualMachines = Get-VM

foreach($vm in $virtualMachines){
    $vhdpath = Get-VHD -VMId $vm.id
    if($vhdpath.Path -like ('*' + $vm.name + '*')){
        $tempVM = $vm
        break
    }
}

#Rename the VM from template name to the desired name
Set-Vm -VM $tempVM -NewVMName $newVmName

#Rename VHD to match VM name and reattach it to the VM on the same controller and location
$vmController = Get-VMHardDiskDrive -VMName $newVmName

Rename-Item -Path ($destinationPath + '\Virtual Hard Disks\*.vhdx') -NewName ($newVmName + '.vhdx')

Set-VMHardDiskDrive -VMName $newVmName `
-ControllerType $vmController.ControllerType `
-ControllerNumber $vmController.ControllerNumber `
-ControllerLocation $vmController.ControllerLocation `
-Path ($destinationPath + '\Virtual Hard Disks\' + $newVmName + '.vhdx')

#Set VLANS on all network adapters (empty = default)
$vmNetAdapters = Get-VMNetworkAdapter -VMName $newVmName

foreach($netAdapter in $vmNetAdapters){
    Write-Host ("`nSet VLAN id for the vm network adapter (leave empty for default) " + $netAdapter.Name) -ForegroundColor Green
    $vlanID = Read-Host
    if($vlanID -eq ""){
        break
    }
    Set-VMNetworkAdapterVlan -Access -VMName $newVmName -VlanId $vlanID -VMNetworkAdapterName $netAdapter.Name
}

#End Result
#TODO display errors if any
Get-Vm -Name $newVmName
Write-Host ("`nVM was sucessfully imported") -ForegroundColor Green