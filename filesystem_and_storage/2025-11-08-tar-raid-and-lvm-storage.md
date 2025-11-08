# tar-raid-and-lvm-storage

*Date:* 2025-11-08

## Overview
Tar (Tape archiver) is a standard linux tool for creating, viewing, and extracting archive files. An archive file is a single file that contains multiple other files and directories, making it easy to store and transport them.
The syntax for Tar goes as follows, `sudo tar <flags> <name of tar file>.tar <whatYouWantBackedUp>'.

Helpful flags for the Tar command:

- c - Create a new archive `tar -cvf archive.tar /path/to/dir`
- x - Extract an archive `tar -xvf archive.tar`
- t - List contents of an archive 'tar -tvf archive.tar'
- f - Specify filename of archive 'tar -cf archive.tar files'
- v - Verbose `tar -cvf ~/backup.tar /home'

LVM stands for logical volume manager and is a powerful tool for managing storage devices on Linux. It adds a layer of abstraction between your physical hard drives and the file systems, allowing for more flexible configurations like resizing volumes on the fly. 

Basic building blocks of LVM:
Physical Volumes (PVs): These are your block devices, such as hard drive partitions or, in our case simulated disks.
Volume Groups (VGs): These are pools of storage created by grouping one or more Physical Volumes together.
Logical Volumes (LVs): These are the “virtual partitions” you create from the space available in a Volume Group. You will create filesystems on these.

In order to get these tools, run 'sudo <yourPackageManager> update && sudo <yourPackageManager> install -y lvm2'.
If you don't have spare physical hard drives, you can simulate them using loop devices which allows a file to be treated as a block device. Create them using `truncate -s <spaceYouWant> <nameOfFile>.img`.
And then use losetup to associate the image files with loop devices `sudo losetup /dev/loop<whateverLoop#> <nameOfFile>.img`.

Now with your block devices, you can create a physical volume from it using `sudo pvcreate /dev/<disk>`.
In order to view you can use the command `sudo pvs`.
From here, you create your Volume Group to group all the Physical Volumes together.
Use `sudo vgcreate <nameForVolumeGroup> /dev/<blockDevice>`.
You can check this Volume Group use 'sudo vgs'.
From here you create your Logical Volume which is the LVM equivalent of a partition. Once created you can format it with a filesystem and mount it to make it accessible for storing data.
To do this, use `sudo lvcreate -L <spaceFollowedByM/G> -n <nameForLogicalVolume> <volumeGroupName>`.
And now using sudo lvs you’ll see your new Logical Volume inside your Volume Group.

Utilizing `sudo mkfs.<fileSystem> /dev/<volumeGroupName>/<logicalVolumeName>`.
A mount point for this partition formatted with a filesystem can easily be created with `sudo mkdir /mnt/<yourMountPointName>`.
With this mountpoint you can now mount your Logical Volume onto it with 'sudo mount /dev/<volumeGroupName>/<logicalVolumeName> /<mountPointName>'.
After all is done, you can view it using the command `df -h <mountPoint>` which will output the mounted logical volume with the free space given by the volume group which was created by the physical volume(s).

Resizing:
`sudo lvresize -r -L <space> <pathToLogicalVolume>` or you can add a plus before the space to add however much.
Configuring Raid:
`sudo <yourPackageManager> update && sudo <yourPackageManager> install -y mdadm` to install RAID.
With your disks or loop devices, use `sudo mdadm –create <nameForRaidDevice> –level=1 –raid-disks=2 <pathToDisks/LoopDevices>`.
To check the status of your raid device, you will have to view the file inside of /proc/mdstat.
From here, you can format its filesystem and mount it as you would with LVM.
In order for the system to rebuild the RAID at boot time, you must add the details of RAID to the conf file which can be done like so `sudo mdadm –detail –scan | sudo tee -a /etc/mdadm/mdadm.conf`.
Now in order for it to be persistently mounted, you must write details of the partition into the fstab file. This can be done by `echo ‘<pathToLogicalVolumeOrRaid> <mountFile> <fileSystem> defaults 0 0’ | sudo tee -a /etc/fstab`.
Then to check its working properly, umount your volumes and then mount using the `-a` flag which checks in the fstab file.

## Key Commands
```bash
sudo tar <flags> <name of tar file>.tar <whatYouWantBackedUp>
truncate -s <spaceYouWant> <nameOfFile>.img
sudo losetup /dev/loop<whateverLoop#> <nameOfFile>.img
sudo pvcreate /dev/<disk>
sudo pvs
sudo vgcreate <nameForVolumeGroup> /dev/<blockDevice>
sudo vgs
sudo lvcreate -L <spaceFollowedByM/G> -n <nameForLogicalVolume> <volumeGroupName>
sudo lvs
sudo mount /dev/<volumeGroupName>/<logicalVolumeName> /<mountPointName>
df -h <mountPoint>
sudo lvresize -r -L <space> <pathToLogicalVolume>
sudo mdadm –create <nameForRaidDevice> –level=1 –raid-disks=2 <pathToDisks/LoopDevices>
sudo mdadm –detail –scan | sudo tee -a /etc/mdadm/mdadm.conf
echo ‘<pathToLogicalVolumeOrRaid> <mountFile> <fileSystem> defaults 0 0’ | sudo tee -a /etc/fstab
```

## Insights
Tar archives are like a moving box full of folders, physical volumes are like individual brings while the volume group is the wall built from bricks, and the logical volume is rooms within the brick walls. Filesystems are like the furniture and labels in each room and mounting is plugging the room into the hallway. Resizing an LVM is like expaning or shrinking a rooms walls and RAID are like mirrored walls sinec everything stored on one disk is instantly duplicated to another, so if one fails, the other still holds the data. Finally the fstab is like the house blueprint since it tells the system where all the rooms (partitions) are and how to connect them each time the house is built (system boots)

## Reflection
> RAID is pretty interesting and I'd like to look more into it.
