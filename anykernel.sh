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
device.name1=begonia
device.name2=begoniain
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

# Kernel installer setup for specific ROM's build.
# Fix/restore bundled LKM (Loadable Kernel Module) provided by Timjosten.
# Fixing issue such as vibration, zram, etc. that may break or not work after installing a oss/custom kernel.
romsign() {
   local prop=""
   local cr_version="ro.crdroid.build.version"
   local evo_version="ro.evolution.build.version"

   for path in /system_root/system/build.prop /system/build.prop; do
      if [ -f "$path" ]; then
         prop="$path"
         break
      fi
   done

   [ -z "$prop" ] && return 1

   if grep -qE "$cr_version|$evo_version" "$prop" && grep -q "timjosten" "$prop"; then
      return 0
   else
      return 1
   fi
}

# boot shell variables
BLOCK=/dev/block/platform/bootdevice/by-name/boot;
PATCH_VBMETA_FLAG=auto;
NO_MAGISK_CHECK=1;

if romsign; then
    BLOCK=boot;
    IS_SLOT_DEVICE=auto;
    RAMDISK_COMPRESSION=none;

    . tools/ak3-core.sh;

    ui_print " ";
    ui_print "Timjosten ROM's detected...";
    ui_print "Applying fix for vibration, zram, etc.";

    split_boot;
    patch_cmdline initcall_blacklist initcall_blacklist=
    flash_boot;

    ui_print " ";
    ui_print "Installing successfully...";
else
    IS_SLOT_DEVICE=0;
    RAMDISK_COMPRESSION=auto;

    . tools/ak3-core.sh;

    dump_boot;
    write_boot;

    ui_print " ";
    ui_print "Installing successfully...";
fi
