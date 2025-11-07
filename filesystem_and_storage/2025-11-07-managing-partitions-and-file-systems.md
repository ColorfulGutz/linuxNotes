# managing-partitions-and-file-systems

*Date:* 2025-11-07

## Overview
`lsblk` will show you all block devices (disks and partitions) attached to the system, providing a clear, tree-like view.
`fdisk` gives a more detailed look at the partition tables of your virtual disk. The flag ***-l*** lists the partition tables for the specified devices and then exits. Running the command without the flag enters its interactive mode where you can create new partitions.
ex: `sudo fdisk /dev/sdb` /dev/sdb being the virtual disk.
In this interactive environment, certain keys, when pressed, enact commands.


Helfpul flags:

m - Show the help menu (lists all commands).
p - Print the current partition table.
v - Verify the partition table for errors.
u - Change the display units (sectors/cylinders).
i -Show detailed information about a specific partition (newer fdisk versions).

Flags for creating and deleting partitions:

n - Create a new partition. Prompts for partition type (primary/logical) and size.
d - Delete a partition. Prompts for which one.
t - Change a partition’s type (e.g., swap, Linux, EFI).
a - Toggle the bootable flag on a partition.
x -Extra functionality (advanced mode) — can adjust geometry, expert settings, etc.

Flags for writing or quitting:

w - Write changes to disk and exit. (Destructive!)
q - Quit without saving changes.
F - List free (unpartitioned) space (newer versions).
g - Create a new GPT partition table (wipes existing).
o - Create a new DOS/MBR partition table (wipes existing).-


`sudo partprobe` asks the kernel to reread the partition table which is normal when dealing with loop devices and to ensure that it recognises the new partition you have made.
A loop device is a special pseudo-device in Linux that lets you treat a regular file as a block device (like a hard drive or partition). This is important to mount disk image files (e.g., .iso, .img) as if they were real disks. Common in testing, virtualization, and installing operating systems. You associate a file with a loop device using the losetup command.
Ex: `sudo losetup /dev/loop0 disk.img`, `sudo mount /dev/loop0 /mnt`.

Now, /mnt acts like a mounted disk, but the data actually lives inside disk.img. Now, /mnt acts like a mounted disk, but the data actually lives inside disk.img.
Since a partition appears as loop…. and youd want something like dev/sdb1, you can do something like this:
`PARTITION_DEVICE=$(lsblk -lno NAME <yourDiskDevice> | grep p1 | head -1)`.
`echo “Partition device: /dev/$PARTITION_DEVICE”`.
And then you'd create a symbolic link for the partition.
`sudo ln -s /dev/$PARTITION_DEVICE <yourPartition>`.


Formatting a partition with a filesystem:

A filesystem provides the structure needed to store and organize files and directories. Without a filesystem, the operating system cannot read from or write to the partition. A default and the most widely used partition system is ext4 for modern Linux distributions. The command to create a filesystem is:
`mkfs` (make filesystem) and can be used as such, `sudo mkfs.ext4 <yourPartition>`.
To verify that the filesystem has been created, you can use `blkid` like such: `sudo blkid <yourPartition>`.
In order to interact and use this, you require a mount point which is simply an empty directory and is standard practice to include it inside /mnt
Ex: `sudo mount <yourPartition> <yourMountPoint>` of course you’d do this after having created the directory inside of mnt

To check if the mount was successful, use command `mountpoint <yourMountPoint>`.
You can check your disk usage with command `df -h <yourMountPoint>` this may show the real device other than the symbolic link, or you can verify with `mount | grep <yourMountPoint>`.
To unmount a partition, be sure to not be in the mountpoint directory and use `sudo umount <yourMountPoint>`.
Now these actions are temporary and after a reboot, none of these will be mounted. In order to have them persistently mounted, you’ll need to add an entry to a special configuration file called /etc/fstab.
Its good practice to copy the fstab file if you accrue any mistakes. You will need the UUID of the device and will then need to nano inside of the fstab config following this syntax `UUID=<yourDeviceIdentifier/UUID> <mountPoint> <filesystemType> <options, Typically default> <dump, Typically 0> <pass, Typically 2>`.
This will look a little something like this:
`UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /data ext4 defaults 0 2`.

Afterwards you want to save the file and run the command `sudo mount -a` which will mount all filesystems listed inside of the file you just edited. You can then verify that the filesystem is mounted with `df -h | grep /data`.
If you have a partition youd like to use as swapspace, you can format it with `sudo mkswap <yourPartition>`.
And you can then check the current swap usage with free -h, to activate it, use `sudo swapon <yourPartition>`.
`swapon -s` does the same as `free -h`.

## Key Commands
```bash
lsblk
fdisk
sudo partprobe
sudo losetup <loopPath> <name>
sudo mount <partition> <mountPoint>
sudo <mkfs.ext orFilesystemOfPreference> <partition>
df -h <mountPoint>
sudo umount <mountPoint>
sudo mkswap <partition>
sudo swapon <partition>
```

## Insights
`lsblk`, `fdisk`, and `partprobe` are often used in sequence when preparing a new disk. `lsblk` to identify the device, `fdisk` to partition it, and `partprobe` to tell the nerl about the changes.
Always double check the device name like `/dev/sdb` before using destructive commands like `fdisk` or `mkfs`. One typo can wipe another drive. Before editing `/etc/fstab`, make a backup with `sudo cp /etc/fstab /etc/fstab.bak`
Think of block devices as containers and filesystems as the organizational system inside the container. Without a filesystem, Linux doesnt know how to find files inside.
Mounting is like "plugging in" the filesystem to your directory tree, unmounting "unplugs" it.
## Reflection
> The syntax for editing the fstab file seems complex but its just a long UUID with its mountpoint, filesystem, and settings.
