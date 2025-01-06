#!/bin/bash
# merge_BAM.cmd
# Merges the coordinate sorted BAMs creating one master BAM per Patient
# usage: sbatch merge_BAM.cmd
# dependencies: SLURM,  SAMtools/1.15
#SBATCH --job-name=MERGE_BAM_PATIENTID
#SBATCH --output=/LogFiles/MERGE_BAM_PATIENTID.%j.out
#SBATCH --error=/LogFiles/MERGE_BAM_PATIENTID.%j.err
#SBATCH -D /path/to/dir

echo "SAMTOOLS MERGE ALL BAMS FOR ID" >&2
module purge

module load SAMtools/1.15-GCC-11.2.0

samtools merge -o CHM13.ID.bam \
CHM13.ID.FL1_1.sort.bam CHM13.ID.FL1_2.sort.bam
CHM13.ID.FL1_3.sort.bam CHM13.ID.FL1_4.sort.bam \
CHM13.ID.FL2_1.sort.bam CHM13.ID.FL2_2.sort.bam
CHM13.ID.FL2_3.sort.bam CHM13.ID.FL2_4.sort.bam
if [ $? -ne 0 ]; then
echo "JOB CANCEL : Error in java application" >&2
exit 1
fi

printf END >&2; uptime >&2
