#!/bin/bash
# VEP_annotation_CHM13.cmd
# Annotates a patient's VCF (aligned to CHM13 assembly) with gnomAD and ClinVar data
# usage: sbatch VEP_annotation_CHM13.cmd
# dependencies: SLURM, VEP
#SBATCH --job-name=VEP_ANNOTATION_CHM13
#SBATCH --output=/LogFiles/VEP_ANNOTATION_CHM13.%j.out
#SBATCH --error=/LogFiles/VEP_ANNOTATION_CHM13.%j.err
#SBATCH -D /path/to/dir

vep \
-i input.CHM13.vcf.gz \
-o output.CHM13.vcf.gz \
--gff chm13v2.0_GENCODEv35_CAT_Liftoff.vep.gff3.gz \
--fasta hsapiens.CHM13.fasta \
--format vcf --vcf --symbol --terms SO \
--custom /Homo_sapiens-GCA_009914755.4-2022_10-gnomad.new_header.vcf.gz,gnomad,vcf,exact,0,AC%AN%AF%AC_fin%AN_fin%AF_fin \
--custom Homo_sapiens-GCA_009914755.4-2022_10-clinvar.vcf.gz,clinvar,vcf,exact,0,ALLELEID%CLNDISDB%CLNDN%CLNHGVS%CLNSIG%CLNVC%CLNVCSO
