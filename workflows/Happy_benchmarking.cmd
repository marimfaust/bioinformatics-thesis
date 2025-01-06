#!/bin/bash
# Happy variant calling benchmarking Nexflow workflow manager
# usage: sbatch Happy_benchmarking.cmd
#SBATCH --job-name=VEP_ANNOTATION_GRCh38
#SBATCH --output=/LogFiles/NEXTFLOW-GENOME-PATIENTID.%j.out
#SBATCH --error=/LogFiles/NEXTFLOW-GENOME-PATIENTID.%j.err
#SBATCH -D /path/to/dir

hostname >&2
printf START >&2; uptime >&2
date >&2


module purge
module load Nextflow/23.04.1

nextflow run \
pipelines/nextflow_benchmarking/main.nf \
-c nfConfigs/cnag_nextflow_queue.config \
-profile singularity \
--wes false \
--tools germline \
--outdir path/to/dir \
--input input.csv \
--fasta hsapiens.fa \
--fasta_fai hsapiens.fa.fai \
--goldset AshkenaziTrio/HG2.vcf.gz \
--bed_conf HG2_smvar.benchmark.bed \
--template_sdf hsapiens.sdf \
-w wd

if [ $? -ne 0 ]; then
        echo "JOB CANCEL : Error in nextflow application" >&2
        exit 1
fi
printf END >&2; uptime >&2
