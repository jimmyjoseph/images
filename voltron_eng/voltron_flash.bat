@echo off
echo ***************************
echo * Voltron Image Update ...
echo ***************************

echo * flash MLO
fastboot flash xloader MLO

echo * flash u-boot.bin
fastboot flash bootloader u-boot.bin

fastboot reboot-bootloader

echo * sleep 5
call :waitsec 5  

echo * format partitions...
fastboot oem format

# EA and SSPAM
fastboot flash EA EA_16K_MPA2.elf
fastboot flash SS voltron_sspam_fw.dat

echo * flash boot.img
fastboot flash boot boot.img

echo * flash system.img
fastboot flash system system.img

echo * flash recovery.img
fastboot flash recovery recovery.img

echo * flash userdata.img
fastboot flash userdata userdata.img

echo * flash cache.img
fastboot flash cache cache.img

echo * flash enterprise.img
fastboot flash enterprise enterprise.img

echo * flash Factory Partition ?
IF NOT "%1"=="cleanfactory" GOTO SkipCleanfactory
echo * Clean Factory Partition
fastboot flash factory factory.img 

:skipcleanfactory

echo * reboot ...
fastboot reboot

GOTO END

:waitsec

@ECHO OFF
IF "%1"=="" GOTO Syntax
ECHO.
ECHO Waiting %1 seconds
ECHO.
@ping 127.0.0.1 -n %1 -w 1000 > nul
exit /b 0

:Syntax
ECHO.
ECHO WAIT for a specified number of seconds
ECHO.
ECHO Usage:  WAIT  n
ECHO.
ECHO Where:  n  =  the number of seconds to wait (1 to 99)
ECHO.

exit /b -1

:END
