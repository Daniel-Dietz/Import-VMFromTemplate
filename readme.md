Use at your own risk!

This script extends functionality of Import-VM powershell command and is made especially for VMs fromn templates/exports.
Importing VM through Hyper-V GUI takes a bit of clicking/typin. This script aims to make the process of spinning up VMs from from template easy and convenient.

Functions
-   Create solid directory structure (VM-NAME(Snapshots,Virtual Machines,Virtual Hard Disks))
-   Rename imported VM to the desired name
-   Rename VHD to match the VM name
-   Let user select which template to use (or which machine to clone)


TODO
-   Dynamically chose template vm store
-   Prevent rewriting existing directories