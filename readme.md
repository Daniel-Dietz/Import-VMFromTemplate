Use at your own risk!

This script extends functionality of Import-VM powershell command and is made especially for VMs fromn templates/exports.
Importing VM through Hyper-V GUI takes a bit of clicking/typin. This script aims to make the process of spinning up VMs from from template easy and convenient.

Functions
-   Creates solid directory structure (VM-NAME(Snapshots,Virtual Machines,Virtual Hard Disks))
-   Keeps naming convention for VM and VHDs
    -   Renames imported VM to the desired name
    -   Renames VHD to match the VM name
-   Gives user option to select template to clone/import


TODO
-   Dynamically chose vm/template store
-   Dynamically select destination path
-   Prevent rewriting existing directories