#!/bin/bash
#SBATCH --job-name=Mutect2_VCF
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=64GB
#SBATCH -n 1

f="$1"
f1="${f%%.bam}"
f2="${f1##*/}"


docker run --rm -w $PWD \
	--mount type=bind,source=$PWD,target=$PWD \
	broadinstitute/gatk \
	java -Dsamjdk.use_async_io_read_samtools=false -Dsamjdk.use_async_io_write_samtools=true -Dsamjdk.use_async_io_write_tribble=false -Dsamjdk.compression_level=2 -jar /gatk/gatk-package-4.4.0.0-local.jar Mutect2 \
	-I "$1" \
	-R Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	--germline-resource af-only-gnomad.hg38.vcf \
	--genotype-germline-sites TRUE \
	--genotype-pon-sites TRUE \
	--interval-padding 50 \
	--max-mnp-distance 0 \
	-O Mutect2_vcf/"$f2".mutect2.unfiltered.vcf.gz


docker run --rm -w $PWD \
	--mount type=bind,source=$PWD,target=$PWD \
	broadinstitute/gatk \
	java -Dsamjdk.use_async_io_read_samtools=false -Dsamjdk.use_async_io_write_samtools=true -Dsamjdk.use_async_io_write_tribble=false -Dsamjdk.compression_level=2 -jar /gatk/gatk-package-4.4.0.0-local.jar FilterMutectCalls \
	-R Homo_sapiens.GRCh38.dna.primary_assembly.fa \
	-V Mutect2_vcf/"$f2".mutect2.unfiltered.vcf.gz \
	-O Mutect2_vcf/"$f2".mutect2.filtered.vcf.gz