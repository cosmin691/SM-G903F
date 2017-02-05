################################################################################
1. How to Build
    - get Toolchain
        From android git server , codesourcery and etc ..

    - edit build_kernel.sh
        edit "CROSS_COMPILE" to right toolchain path(You downloaded).
        Ex) export CROSS_COMPILE=/*/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-    // You have to check.        

    $ build_kernel.sh

2. Output filesS
    - Kernel : output/arch/arm/boot/zImage
    - module : output/drivers/*/*.ko

3. How to Clean	
    $ cd output
    $ make clean
################################################################################
