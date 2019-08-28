#Use this script at your own risk
#TODO - dynamically select templates
$vmStorePath = "D:\Hyper-V exports\"
$templates = Get-ChildItem -Path $vmStorePath
$index = 1

foreach($template in $templates){
    Write-Output $index + ' - ' + $template.Name
    $index++
}

Write-Host 'Select VM to clone:'
$selectedIndex = Read-Host

#Modify the variables to suit your needs
$vmcxPath = 'D:\Hyper-V exports\CENTOS7-template\Virtual Machines\22C1E1A1-458E-4741-B3AA-D7C46A178F37.vmcx'
$newVmName = ""

#Get VM name and set the detination path
Write-Output 'Insert name for the new VM:'
$newVmName = Read-Host

#Set destination path
$destinationPath = 'F:\VirtualMachines\' + $newVmName

#import virtual machine
#TODO check if the path is already used
Write-Output '`nImporting machine ' + $newVmName 
Import-VM -Path $vmcxPath `
    -copy  `
    -GenerateNewId `
    -SnapshotFilePath  ($destinationPath + '\Snapshots') `
    -VhdDestinationPath ($destinationPath + '\Virtual Hard Disks') `
    -VirtualMachinePath ($destinationPath)

#Get ID of the newly created VM
$virtualMachines = Get-VM

foreach($vm in $virtualMachines){
    $vhdpath = Get-VHD -VMId $vm.id | Select-Object -ExpandProperty Path
    if($vhdpath -like ('*' + $vm.name + '*')){
        $tempVM = $vm
        break
    }
}

#Rename the VM from template name to the desired name
Set-Vm -VM $tempVM -NewVMName $newVmName

#TODO Rename VHD to match VM name and reattach it