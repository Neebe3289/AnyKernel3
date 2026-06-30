### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=onyx
device.name2=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

## boot shell variables
BLOCK=boot;
IS_SLOT_DEVICE=auto;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching
. tools/ak3-core.sh;

# boot install
if [ -L "/dev/block/bootdevice/by-name/init_boot_a" ] || [ -L "/dev/block/by-name/init_boot_a" ]; then
	split_boot;	# for devices with init_boot ramdisk
	flash_boot;	# for devices with init_boot ramdisk
else
	dump_boot;	# use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk
	write_boot;	# use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
fi
## end boot install
