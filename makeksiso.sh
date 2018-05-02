#!/bin/bash

if [ "$2" == "" ]; then
  echo "Usage: ./makeksiso.sh <INPUT ISO> <OUTPUT ISO>"
  exit 1
fi

thisfolder=${BASH_SOURCE%/*}
inputiso=$1
outputiso=$2

isomount=$thisfolder/isomount
workingdir=$thisfolder/workingdir

mkdir $isomount
mkdir $workingdir

mount -o loop $inputiso $isomount
cp -r $isomount/* $workingdir
umount $isomount
rmdir $isomount

chmod -R u+w $workingdir

mkdir $workingdir/isolinux/ks
cp -r $thisfolder/ks/* $workingdir/isolinux/ks
cp -f $thisfolder/isolinux.cfg $workingdir/isolinux/

label=$(dd if=$inputiso bs=1 skip=32808 count=32 2>/dev/null)

mkisofs -o $outputiso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -V "$label" -R -J -v -T $workingdir/

rm -rf $workingdir