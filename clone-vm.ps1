#Use this script at your own risk
#TODO - dynamically select vmcx files

#Modify the variables to suit your needs
$vmcxPath = 'D:\Hyper-V exports\CENTOS7-template\Virtual Machines\22C1E1A1-458E-4741-B3AA-D7C46A178F37.vmcx'
$newVmName = ""
$newVmId = ''

#Get VM name and set the detination path
Write-Output 'Insert vm name:'
$newVmName = Read-Host
$destinationPath = 'F:\VirtualMachines\' + $newVmName

#import virtual machine
#TODO - Create folders in final destination for VHDs, snapshots, vms etc 
Write-Output 'Importing machine ' $newVmName 
Import-VM -Path $vmcxPath `
    -copy  `
    -GenerateNewId `
    -SnapshotFilePath  ($destinationPath + '\Snapshots') `
    -VhdDestinationPath ($destinationPath + '\Virtual Hard Disks') `
    -VirtualMachinePath ($destinationPath)

#TODO Rename the vm to the desired name
$virtualMachines = Get-VM

foreach($vm in $virtualMachines){
    $vhdpath = Get-VHD -VMId $vm.id | Select-Object -ExpandProperty Path
    if($vhdpath -like ('*' + $vm.name + '*')){
        $newVmId = $vm.Id
        break
    }
}



