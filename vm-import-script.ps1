#Use this script at your own risk
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

Write-Host ("`nImporting VM: " + $newVmName ) -ForegroundColor Green
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

#TODO Rename VHD to match VM name and reattach it

#End Result
#TODO display errors if any
Get-Vm -Name $newVmName
Write-Host ("`nVM was sucessfully imported") -ForegroundColor Green