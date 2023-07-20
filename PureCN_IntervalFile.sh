#!/bin/bash

#SBATCH --job-name=PureCN_IntervalFile
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=12GB
#SBATCH -n 1


##### Usage sbatch PureCN_IntervalFile.sh final_bed_intersects.modified.bed

docker run --rm -w ${pwd} --mount type=bind,source=${pwd},target=${pwd} markusriester/purecn Rscript /opt/PureCN/IntervalFile.R \
    --in-file $1 \
    --fasta GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
    --out-file PureCN_intervals.txt \
    --off-target \
    --genome hg38 \
    --mappability GCA_000001405.15_GRCh38_no_alt_analysis_set_76.bw \
    --force