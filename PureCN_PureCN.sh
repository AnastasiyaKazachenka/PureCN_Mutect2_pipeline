#!/bin/bash
#SBATCH --job-name=PureCN_Normal_DB
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=10GB
#SBATCH -n 1

f="$1"
f1="${f%%_coverage_loess.txt.gz}"
f2="${f1##*/}"

echo "$f1"
echo "$f2"

if [ ! -d "./PureCN_PureCN" ]; then
    mkdir -p "./PureCN_PureCN"
fi


docker run --rm -w $PWD --mount type=bind,source=$PWD,target=$PWD markusriester/purecn Rscript /opt/PureCN/PureCN.R \
	--out PureCN_PureCN/"$f2"_filtered \
    --tumor "$1" \
    --sampleid "$f2"_filtered \
    --vcf Mutect2_vcf/"$f2".mutect2.filtered.vcf.gz \
    --normaldb PureCN_normalDB/normalDB_hg38.rds \
    --mappingbiasfile PureCN_normalDB/mapping_bias_hg38.rds \
    --intervals PureCN_intervals.modified.txt \
    --snp-blacklist hg38_simpleRepeats.modified.bed \
    --genome hg38 \
    --force --post-optimize --seed 123





