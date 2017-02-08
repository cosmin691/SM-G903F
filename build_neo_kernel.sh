#!/bin/sh

DTS=arch/arm64/boot/dts

echo "Clear Folder"
make clean
echo "make config"
make s5neolte_defconfig
echo "build kernel"
make exynos7580-universal7580.dtb
make exynos7580-universal7580_rev01.dtb
make exynos7580-universal7580_q.dtb
make ARCH=arm64

echo "Build dt.img"

./tools/dtbtool -o ./dt.img -v -s 2048 -p ./scripts/dtc/ $DTS/

# eliminate temp file in dts directory
rm -rf $DTS/.*.tmp
rm -rf $DTS/.*.cmd
rm -rf $DTS/*.dtb

# Calculate DTS size for all images and display on terminal output
du -k "./dt.img" | cut -f1 >sizT
sizT=$(head -n 1 sizT)
rm -rf sizT
echo "$sizT Kb"
