#! /bin/sh

#BSUB -J PER_#RES_#NBLK_#NPROC_GNU
#BSUB -u fabian.gabel@stud.tu-darmstadt.de
#BSUB -B -N

#BSUB -e /home/gu08vomo/output/GNU/#RES_#NBLK/#RES_#NBLK_#NPROC.err.%J
#BSUB -o /home/gu08vomo/output/GNU/#RES_#NBLK/#RES_#NBLK_#NPROC.out.%J

#BSUB -n #NPROC
#BSUB -W 24:00
#BSUB -x

#BSUB -a openmpi

module load openmpi/gcc/1.8.1
export PETSC_DIR=/home/gu08vomo/soft/petsc/3.5.1/build/arch-openmpi-opt-gnu
export MYWORKDIR=/work/scratch/gu08vomo/performance/#RES_#NBLK/#RES_#NBLK_#NPROC/

echo "PETSC_DIR="$PETSC_DIR
echo "MYWORKDIR="$MYWORKDIR

cd ${MYWORKDIR}
pwd
cd caffa.MTM
#git checkout master
#git pull origin master
cd caffa3d.MB
cp ../../param3d.inc .
cp control.cin ../../.
make opt-gnu-analytical EXPATH=${MYWORKDIR}
cd ${MYWORKDIR}

mpirun -n #NPROC ./caffa3d.MB.lnx -log_summary /home/gu08vomo/output/GNU/#RES_#NBLK/#RES_#NBLK_#NPROC.log.${LSB_JOBID}
