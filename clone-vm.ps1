#Use this script at your own risk!!
#Modify the variables to suit your needs
$vmcxPath = 'D:\Hyper-V exports\CENTOS7-template\Virtual Machines\22C1E1A1-458E-4741-B3AA-D7C46A178F37.vmcx'
$destinationPath = 'F:\VirtualMachines'
$newVmName = 

#Get name for the new VM

#import virtual machine
Import-VM -Path $vmcxPath -copy  -GenerateNewId