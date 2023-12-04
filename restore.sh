#!/bin/bash
cd /home/test
export DEV=/dev/mmcblk0
if [ ! -b $DEV ] ; then
  export DEV=/dev/nvme0n1
fi
umount $DEV*
lsblk $DEV
MENU=
CNT=0
for x in `ls *.img.gz`
do
    CNT=$[CNT+1]
    SIZE=`date -r "$x" +"%y-%m-%d"`
    MENU="${MENU} $x ${SIZE}"
done
echo ${MENU}
IN=$(dialog --clear --no-shadow \
    --title "Select file:" \
    --menu "Use + arrows to select and (A) button to confirm" \
         -1 -1 ${CNT} \
         ${MENU} \
    2>&1 >$(tty))
clear
case ${IN} in
*.img.gz)
    ;;
*)
    exit 1
    ;;
esac

  sudo sh -c "gunzip -c $IN | sudo dd of=$DEV bs=1M status=progress && reboot"
#export PART=${DEV}p2
#gunzip -c ./backup.p2.img.gz | pv -s 20G | dd of=$PART
#e2fsck -f $PART
#resize2fs $PART
#mkdir /mnt/mmc
#mount $PART /mnt/mmc
#grub-install --boot-directory=/mnt/mmc/boot $MMC --force

(speaker-test -t sine -f 1000 >/dev/null)& pid=$!; sleep 1s; kill -9 $pid
sleep 10
