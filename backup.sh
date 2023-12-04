export DEV=/dev/mmcblk0
if [ ! -b $DEV ] ; then
  export DEV=/dev/nvme0n1
fi
export SIZE_MB=`echo unit MiB print | sudo parted $DEV | grep ext4 | tail -n 1 | awk '{sub("MiB","",$3); print $3+1}'`
export BOOT=${DEV}boot
lsblk $DEV
echo size: $SIZE_MB MB
read -p 'Tag:' TAG
if [ ! -z "$TAG" ] ; then
  export OUT=./backup.$TAG.img.gz
else
  exit 1
  export OUT=./backup.img.gz
fi
echo Backup $SIZE_MB MiB from $DEV to $OUT ...
sudo sh -c "dd if=$DEV bs=1M count=${SIZE_MB} status=progress | gzip -c | tee $OUT | sha256sum | cut -d ' ' -f 1 && echo $OUT" | paste -d '  ' -s > $OUT.sha256
ls -l $OUT
cat $OUT.sha256
#lsblk ${BOOT}0
#dd if=${BOOT}0 bs=1M status=progress | gzip -c > ./backup.mmcblk0boot0.img.gz
#lsblk ${BOOT}1
#dd if=${BOOT}1 bs=1M status=progress | gzip -c > ./backup.mmcblk0boot1.img.gz
(speaker-test -t sine -f 1000 > /dev/null)& pid=$!; sleep 1s; kill -9 $pid
