#!/bin/bash
echo "Flashing Android Gingerbread release"
echo "Do not disconnect..."

echo "Flashing bootloader....."
./fastboot flash xloader ./MLO
./fastboot flash bootloader ./u-boot.bin

echo "Reboot bootloader: make sure new bootloader runs..."
./fastboot reboot-bootloader
sleep 5

echo "Create GPT partition table..."
./fastboot oem format

# EA and SSPAM
./fastboot flash EA ./EA_16K_MPA2.elf
./fastboot flash SS ./voltron_sspam_fw.dat

#Generic Android partitions
echo "Flash android partitions..."
./fastboot flash boot ./boot.img
./fastboot flash recovery ./recovery.img
./fastboot flash system ./system.img
./fastboot flash userdata ./userdata.img
./fastboot flash cache ./cache.img

# not sure if we need to flash enterprise and factory
./fastboot flash enterprise ./enterprise.img
if [ "$1"  == "cleanfactory" ];
then
    echo "Clean Factory Partition"
    ./fastboot flash factory ./factory.img
fi

echo "Reboot to new OS..."
#reboot
./fastboot reboot
echo "Done..."

