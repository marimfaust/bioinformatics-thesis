#!/bin/bash
# variant_calling_chromosomal_22.cmd
# Performs variant calling on the patient's BAM, per chromosome
# This is a chromosome 22 example
# usage: sbatch variant_calling_chromosomal.cmd
# dependencies: SLURM, GATK/4.4.0.0
#SBATCH --job-name=VARIANT_CALLING_CHROMOSOMAL
#SBATCH --output=/LogFiles/VARIANT_CALLING_CHROMOSOMAL.%j.out
#SBATCH --error=/LogFiles/VARIANT_CALLING_CHROMOSOMAL.%j.err
#SBATCH -D /path/to/dir

hostname >&2
printf START >&2; uptime >&2
date >&2

echo "Running GATK HAPLOTYPECALLER on chr22" >&2
module purge

export TMPDIR="/path/to/TMP"

apptainer \
exec \
--no-home \
--bind /scratch_isilon \
/scratch_isilon/groups/dat/apps/GATK/4.4.0.0/gatk_4.4.0.0.sif \
gatk --java-options "-Xmx16g" HaplotypeCaller \
-R /path/to/hsapiens.CHM13.fasta \
-I CHM13.ID.sort.MD.bam \
-O CHM13.ID.chr22.g.vcf.gz \
--tmp-dir ${TMPDIR} \
--emit-ref-confidence GVCF \
--phred-scaled-global-read-mismapping-rate 20 \
--native-pair-hmm-threads 4 \
--intervals chr22
