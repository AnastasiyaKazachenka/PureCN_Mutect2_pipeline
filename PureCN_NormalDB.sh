#!/bin/bash
#SBATCH --job-name=PureCN_Normal_DB
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=64GB
#SBATCH -n 1


#Usage: sbatch PureCN_NormalDB.sh

if [ ! -d "./PureCN_normalDB" ]; then
    mkdir -p "./PureCN_normalDB"
fi


ls -a ./PureCN_Coverage/*_coverage_loess.txt.gz | cat > ./PureCN_normalDB/normalDB_102.list

																	
docker run --rm -w $PWD --mount type=bind,source=$PWD,target=$PWD markusriester/purecn Rscript /opt/PureCN/NormalDB.R \
   --out-dir ./PureCN_normalDB\
   --coveragefiles ./PureCN_normalDB/normalDB_102.list \
   --normal_panel  Mutect2_PON_DB \
   --genome hg38 --force