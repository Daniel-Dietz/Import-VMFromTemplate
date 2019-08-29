#Use this script at your own risk
#This script is made only for Hyper-V 2016 and later

#TODO input arguments VMNAME, VLAN, DESTINATION, TEMPLATE
#TODO Refactor, create functions, clean up code
#TODO Dynamically select vm store
#TODO Hyper-V 2012 R2 compatibility (xml config files instead of vmcx)

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
$vmcxPath = Get-Childitem -Path ($vmStorePath + $templates[$selectedIndex-1].Name + '\Virtual Machines\') -Recurse -Include '*.vmcx'


#Get VM name and set the detination path
Write-Host 'Insert name for the new VM:' -ForegroundColor Green
$newVmName = Read-Host

#Set destination path
$destinationPath += $newVmName

#import virtual machine

#Checks if destination path is available
#TODO promp if folder exists but is empty
if(Test-Path -Path $destinationPath){
    Throw ("Directory " + $destinationPath + " already exists")
}

Write-Host ("`nImporting VM " + $newVmName + " please wait...") -ForegroundColor Yellow
Import-VM -Path $vmcxPath `
    -copy  `
    -GenerateNewId `
    -SnapshotFilePath  ($destinationPath + '\Snapshots') `
    -VhdDestinationPath ($destinationPath + '\Virtual Hard Disks') `
    -VirtualMachinePath ($destinationPath) `
    | out-null

#Get ID of the newly created VM
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

#TODO Get/Set vm network adapter vlan 
$vmNetAdapters = Get-VMNetworkAdapter -VMName $newVmName

foreach($netAdapter in $vmNetAdapters){
    Write-Host ("`n Set VLAN id for the vm network adapter " + $netAdapter.Name) -ForegroundColor Green
    $vlanID = Read-Host

    Set-VMNetworkAdapterVlan -VMName $newVmName -VlanId $vlanID -VMNetworkAdapterName $netAdapter
}


#End Result
#TODO display errors if any
Get-Vm -Name $newVmName
Write-Host ("`nVM was sucessfully imported") -ForegroundColor Green