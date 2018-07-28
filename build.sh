#!/bin/bash

# Copyright (C) 2018 Luan Halaiko (tecnotailsplays@gmail.com)
#                    Abubakar Yagob (abubakaryagob@gmail.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#Colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[1;35m'
cyan='\033[0;36m'
nc='\033[0m'

#Directories
KERNEL_DIR=$PWD
KERN_IMG=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=/media/oveno/649AC4299AC3F6181/zucc/Output/Zipper
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs

#Export
export CROSS_COMPILE=/media/oveno/649AC4299AC3F6181/xtended/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android- 
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="Ovenoboyo"
export KBUILD_BUILD_HOST="Kekboi"

#clang
#export CLANG_COMPILE=true
#export CLANG_TRIPLE=aarch64-linux-android-
#export CLANG_PATH="/media/oveno/649AC4299AC3F6181/xtended/prebuilts/clang/host/linux-x86/clang-4053586"
#CC="/media/oveno/649AC4299AC3F6181/xtended/prebuilts/clang/host/linux-x86/clang-4053586/bin/clang"

#Misc
CONFIG=zucc_defconfig
THREAD="-j4"

#Main script
while true; do
echo -e "\n$green[1] Build Kernel"
echo -e "[2] Regenerate defconfig"
echo -e "[3] Source cleanup"
echo -e "[4] Create flashable zip"
echo -e "$red[5] Quit$nc"
echo -ne "\n$brown(i) Please enter a choice[1-6]:$nc "

read choice

if [ "$choice" == "1" ]; then
  BUILD_START=$(date +"%s")
  DATE=`date`
  echo -e "\n$cyan#######################################################################$nc"
  echo -e "$brown(i) Build started at $DATE$nc"
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out $CONFIG $THREAD &>/dev/null \
						     
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out $THREAD &>/media/oveno/649AC4299AC3F6181/zucc/Output/log/Buildlog.txt & pid=$! \

  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  if ! [ -a $KERN_IMG ]; then
    echo -e "\n$red(!) Kernel compilation failed, See buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    exit 1
  fi
  $DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/ &>/dev/null &>/dev/null

  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Image-dtb compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i) Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "2" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out  $CONFIG
  cp /media/oveno/649AC4299AC3F6181/zucc/Output/build/out/.config arch/arm64/configs/$CONFIG
  echo -e "$purple(i) Defconfig generated.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "3" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  rm -f $DT_IMG
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out clean &>/dev/null
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out mrproper &>/dev/null
  rm -rf /media/oveno/649AC4299AC3F6181/zucc/Output/build/out
  echo -e "$purple(i) Kernel source cleaned up.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "4" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  cd $ZIP_DIR
  make clean &>/dev/null
  cp $KERN_IMG $ZIP_DIR/Image.gz-dtb
  make &>/dev/null
  make sign &>/dev/null
  cd /media/oveno/649AC4299AC3F6181/zucc/bak/EAS
  echo -e "$purple(i) Flashable zip generated under $ZIP_DIR.$nc"
  echo -e "$cyan#######################################################################$nc"
fi

if [ "$choice" == "5" ]; then
 exit 1
fi

if [ "$choice" == "6" ]; then
  BUILD_START=$(date +"%s")
  DATE=`date`
  echo -e "\n$cyan#######################################################################$nc"
  echo -e "$brown(i) Build started at $DATE$nc"
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out $CONFIG $THREAD &>/dev/null \
						     
  make O=/media/oveno/649AC4299AC3F6181/zucc/Output/build/out  CONFIG_DEBUG_SECTION_MISMATCH=y $THREAD &>/media/oveno/649AC4299AC3F6181/zucc/Output/log/Buildlog.txt & pid=$! \

  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  if ! [ -a $KERN_IMG ]; then
    echo -e "\n$red(!) Kernel compilation failed, See buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    exit 1
  fi
  $DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/ &>/dev/null &>/dev/null

  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Image-dtb compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i) Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
fi
done


make CONFIG_DEBUG_SECTION_MISMATCH=y

