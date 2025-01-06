#!/bin/bash
# index_BAM.cmd
# Creates an index file of the patient's BAM file for variant calling
# usage: sbatch index_BAM.cmd
# dependencies: SLURM, SAMtools/1.15
#SBATCH --job-name=INDEX_BAM_PATIENTID
#SBATCH --output=/LogFiles/INDEX_BAM_PATIENTID.%j.out
#SBATCH --error=/LogFiles/INDEX_BAM_PATIENTID.%j.err
#SBATCH -D /path/to/dir

samtools index -b /path/to/CHM13.ID.sort.MD.bam
