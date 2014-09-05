#! /bin/bash

res=128
nblk=128

for i in 1 2 4 8 16 32 64 128
do
  cp intel-jobs.sh 128_128_$i/.
  cp -rf caffa.MTM 128_128_$i/.
  cd 128_128_$i
  sed -i -e "s/#RES/$res/g" -e "s/#NBLK/$nblk/g" -e "s/#NPROC/$i/g" intel-jobs.sh
  cd ..
done

