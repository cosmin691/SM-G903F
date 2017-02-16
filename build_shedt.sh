#!/bin/sh

ARCH=arm64
CROSS_COMPILE=/home/wilmans2m/toolchains/google/bin/aarch64-linux-android-
BUILD_KERNEL_DIR=$(pwd)
DTOUT=$BUILD_KERNEL_DIR/arch/arm64/boot/dt.img
DTSDIR=$BUILD_KERNEL_DIR/arch/arm64/boot/dts
DTFILE=$BUILD_KERNEL_DIR/arch/arm64/boot/dtfiles

FUNC_CLEAN_DTB()
{
	if ! [ -d $DTSDIR ] ; then
		echo "no directory : "$DTSDIR""
	else
		echo "remove built dts/dtb/dt.img files"
		rm $DTOUT
	fi
}

if ! [ -d $DTFILE ] ;
then
mkdir $DTFILE
fi

DTC=$BUILD_KERNEL_DIR/scripts/dtc/dtc
DTSFILES="exynos7580-s5neo_rev00 exynos7580-s5neo_rev06 exynos7580-s5neo_rev07 exynos7580-s5neo_rev08 exynos7580-s5neo_rev09 exynos7580-s5neo_rev11"
DTBTOOL=$BUILD_KERNEL_DIR/tools/dtbtool
PAGE_SIZE=2048
DTB_PADDING=0

FUNC_BUILD_DTB()
{
	echo ""
	echo "================================="
	echo "START : FUNC_BUILD_DTB"
	echo "================================="
	echo ""

	for dts in $DTSFILES; do
		echo "=> Processing: ${dts}.dts"
		"${CROSS_COMPILE}cpp" -nostdinc -undef -x assembler-with-cpp -I "$BUILD_KERNEL_DIR/include" "$DTSDIR/${dts}.dts" > "arch/arm64/boot/dtfiles/${dts}.dts"
		echo "=> Generating: ${dts}.dtb"
		$DTC -p $DTB_PADDING -i "$DTSDIR" -O dtb -o "arch/arm64/boot/dtfiles/${dts}.dtb" "arch/arm64/boot/dtfiles/${dts}.dts"
	done

	echo ""
	echo "================================="
	echo "END   : FUNC_BUILD_DTB"
	echo "================================="
	echo ""
}

FUNC_BUILD_DTIMG()
{
	echo ""
	echo "================================="
	echo "START : FUNC_BUILD_DTIMG"
	echo "================================="
	echo ""

	echo "Generating dt.img..."
	$DTBTOOL -o $DTOUT -v -s $PAGE_SIZE -p ./scripts/dtc/ $DTFILE/

	echo ""
	echo "================================="
	echo "END   : FUNC_BUILD_DTIMG"
	echo "================================="
	echo ""
}

# MAIN DT FUNCTION
rm -rf ./build.log
(
    START_TIME=`date +%s`

	FUNC_CLEAN_DTB
	FUNC_BUILD_DTB
	FUNC_BUILD_DTIMG
	rm -rf $DTFILE

    END_TIME=`date +%s`

    echo "Total compile time is $ELAPSED_TIME seconds"
) 2>&1	| tee -a ./build.log

# Calculate DTS size for all images and display on terminal output
du -k "$DTOUT" | cut -f1 >sizT
sizT=$(head -n 1 sizT)
rm -rf sizT
echo "DT.img is $sizT Kb"