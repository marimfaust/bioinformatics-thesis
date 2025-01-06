#!/bin/bash
# VEP_annotation_GRCh38.cmd
# Annotates a patient's VCF (aligned to GRCh38 assembly) with gnomAD and ClinVar data
# usage: sbatch VEP_annotation_GRCh38.cmd
# dependencies: SLURM, VEP
#SBATCH --job-name=VEP_ANNOTATION_GRCh38
#SBATCH --output=/LogFiles/VEP_ANNOTATION_GRCh38.%j.out
#SBATCH --error=/LogFiles/VEP_ANNOTATION_GRCh38.%j.err
#SBATCH -D /path/to/dir

vep \
-i input.GRCh38.vcf.gz \
-o output.GRCh38.vcf.gz \
--gff gencode.v38.annotation.gff3 \
--fasta hsapiens.GRCh38.hl.fasta \
--format vcf --vcf --symbol --terms SO
