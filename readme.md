# Hyper-V VM Import Script

Use at your own risk!

This script extends functionality of Import-VM powershell command and is made especially for importing VMs from templates/exports.
Importing VM through Hyper-V GUI takes a bit of clicking/typin. This script aims to make the process of spinning up VMs from from template easy and convenient.

The script is only compatible with Hyper-V 2016 and newer

Functions
-   Creates solid directory structure (VM-NAME(Snapshots,Virtual Machines,Virtual Hard Disks))
-   Keeps naming convention for VM and VHDs
    -   Renames imported VM to the desired name
    -   Renames VHD to match the VM name
-   Gives user option to select template to clone/import on each run


TODO
-   Dynamically chose vm/template store
-   Dynamically select destination path
-   Prevent rewriting of existing directories
-   Hyper-V 2012 R2 compatibility (uses xml config files instead of vmcx)