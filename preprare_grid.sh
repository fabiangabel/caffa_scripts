#! /bin/bash

declare -a PROCS=(1 2 4 8 16 32 64 128 256 512 1024)
#declare -a PROCS=(1)
RES="128"
NBLOCKS="1024"

rm -rf caffa.MTM
git clone ssh://gabel@neptun.fnb.maschinenbau.tu-darmstadt.de/amd/home/gabel/share/caffa.MTM.git
cd caffa.MTM/grgen3d.MB
gfortran grid.f90 -o ../../grid.out
make DPATH=../.. CFORT=gfortran
cd ..
gfortran w_preprocessor.F -o ../w_preproc.out
cd ..

mkdir -v "$RES"_"$NBLOCKS"_"${PROCS[0]}"
cd "$RES"_"$NBLOCKS"_"${PROCS[0]}"
ln -s ../grid.out
ln -s ../grgen
ln -s ../w_preproc.out
./grid.out <grid.inp
./grgen <grgen.inp
cd ..

echo "W_PREPROC"
for i in "${PROCS[@]}" 
do
  CASENAME=${RES}_${NBLOCKS}_${i}
  cp -rf ${RES}_${NBLOCKS}_1 ${CASENAME}
  sed "s/#NPROCS/$i/g" control.txt >${CASENAME}/control.txt
  cd ${CASENAME}
  ./w_preproc.out 
  cd ..
done

echo "BLOCK3D"
for i in "${PROCS[@]}" 
do
  DEST="../../${RES}_${NBLOCKS}_${i}"
  SRC="caffa.MTM/block3d.MB"
  cd ${SRC}
  cp -v ${DEST}/param3d.inb .
  make clean 
  make -f Makefile.fnb clip-build EXPATH=${DEST}/
  cd ${DEST}
  numactl --localalloc --cpunodebind=5 ./block3d.MB.lnx 
  cd ..
done
