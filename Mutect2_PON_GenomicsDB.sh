#!/bin/bash
#SBATCH --job-name=Mutect2_GenomicDB
#SBATCH --output ./slurm_out/%j_slurm.out
#SBATCH --error ./slurm_err/%j_slurm.err
#SBATCH --mem=64GB
#SBATCH -n 1


##### Usage sbatch Mutect2_PON_GenomicsDB.sh


docker run --rm -w ${pwd} \
	--mount type=bind,source=${pwd},target=${pwd} \
	broadinstitute/gatk \
	java -Dsamjdk.use_async_io_read_samtools=false -Dsamjdk.use_async_io_write_samtools=true -Dsamjdk.use_async_io_write_tribble=false -Dsamjdk.compression_level=2 -jar /gatk/gatk-package-4.4.0.0-local.jar GenomicsDBImport \
    -R Homo_sapiens.GRCh38.dna.primary_assembly.fa \
    -L final_bed_intersects.interval_list \
    --batch-size 5 \
    --consolidate true \
    --merge-input-intervals \
    --genomicsdb-workspace-path Mutect2_PON_DB \
    --sample-name-map Normal_Mutect2_vcf.sample_map


docker run --rm -w ${pwd} \
    --mount type=bind,source=${pwd},target=${pwd} \
    broadinstitute/gatk \
    java -Dsamjdk.use_async_io_read_samtools=false -Dsamjdk.use_async_io_write_samtools=true -Dsamjdk.use_async_io_write_tribble=false -Dsamjdk.compression_level=2 -jar /gatk/gatk-package-4.4.0.0-local.jar CreateSomaticPanelOfNormals \
    -R Homo_sapiens.GRCh38.dna.primary_assembly.fa \
    --germline-resource af-only-gnomad.hg38.vcf \
    -V gendb://Mutect2_PON_DB \
    -O pon.vcf.gz