#Use this script at your own risk
#TODO - dynamically select vmcx files

#Modify the variables to suit your needs
$vmcxPath = 'D:\Hyper-V exports\CENTOS7-template\Virtual Machines\22C1E1A1-458E-4741-B3AA-D7C46A178F37.vmcx'
$newVmName = "IMPORT-TEST"

#Get name for the new VM
#Write-Output 'Insert vm name:'
#$newVmName = Read-Host

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