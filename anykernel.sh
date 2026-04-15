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

# Kernel installer setup for specific builds.
# Automatically detect specific ROM build signatures.
# Restore bundled native Loadable Kernel Module (LKM) in Timjosten ROMs
# To fixing issue such as vibration, zram that may break or not work after installing a custom kernel.
romsign() {
   for path in /system_root/system/build.prop /system/build.prop; do
      if [ -f "$path" ]; then
         if grep -qE "ro.crdroid.build.version|ro.evolution.build.version" "$path" && grep -q "timjosten" "$path"; then
            return 0
         fi
      fi
   done
   return 1
}

# boot shell variables
BLOCK=/dev/block/platform/bootdevice/by-name/boot;
IS_SLOT_DEVICE=auto;
PATCH_VBMETA_FLAG=auto;

if romsign; then
    BLOCK=boot;
    RAMDISK_COMPRESSION=none;
    NO_MAGISK_CHECK=1;

    . tools/ak3-core.sh;

    ui_print " ";
    ui_print "Timjosten ROM detected...";
    ui_print "Applying vibration, zram fixes...";

    split_boot;
    patch_cmdline initcall_blacklist initcall_blacklist=;
    flash_boot;

    ui_print " ";
    ui_print "Installation completed.";
else
    RAMDISK_COMPRESSION=auto;

    . tools/ak3-core.sh;

    ui_print " ";
    ui_print "Installing kernel...";

    dump_boot;
    write_boot;

    ui_print " ";
    ui_print "Installation completed.";
fi

