#!/bin/bash
#SBATCH --job-name=Mutect2_VCF
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=64GB
#SBATCH -n 1

##### Usage sbatch Mutect2_PON_makeVCF.sh <my_bam>.bam
##### parallel 'sbatch Mutect2_PON_makeVCF.sh {}' ::: *.bam


f="$1"
f1="${f%%.bam}"
f2="${f1##*/}"

if [ ! -d "Mutect2_vcf" ]; then
    mkdir -p "Mutect2_vcf"
fi

docker run --rm -w ${pwd} \
	--mount type=bind,source=${pwd},target=${pwd} \
	broadinstitute/gatk \
	java -Dsamjdk.use_async_io_read_samtools=false -Dsamjdk.use_async_io_write_samtools=true -Dsamjdk.use_async_io_write_tribble=false -Dsamjdk.compression_level=2 -jar /gatk/gatk-package-4.4.0.0-local.jar Mutect2 \
	-I "$1" \
	-R Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	--genotype-germline-sites TRUE \
	--genotype-pon-sites TRUE \
	--interval-padding 50 \
	--max-mnp-distance 0 \
	-O Mutect2_vcf/"$f2".mutect2.vcf.gz


