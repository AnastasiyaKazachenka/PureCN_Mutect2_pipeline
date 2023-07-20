#!/bin/bash
#SBATCH --job-name=PureCN_Cov
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=64GB
#SBATCH -n 1

##### Usage sbatch PureCN_Coverage.sh <my_bam>.bam
##### parallel 'sbatch PureCN_Coverage.sh {}' :::: *.bam


if [ ! -d "./PureCN_Coverage" ]; then
    mkdir -p "./PureCN_Coverage"
fi


docker run --rm -w $PWD --mount type=bind,source=$PWD,target=$PWD markusriester/purecn Rscript /opt/PureCN/Coverage.R \
   --out-dir ./PureCN_Coverage \
   --bam "$1" \
   --intervals PureCN_intervals.modified.txt