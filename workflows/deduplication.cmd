#!/bin/bash
# deduplication.cmd
# Removes duplicate sequences from the mBAM patient file, avoiding sequence over-representation and biased variant calling
# usage: sbatch deduplication.cmd
# dependencies: SLURM, GATK/4.4.0.0
#SBATCH --job-name=DEDUPLICATION_PATIENTID
#SBATCH --output=/LogFiles/DEDUPLICATION_PATIENTID.%j.out
#SBATCH --error=/LogFiles/DEDUPLICATION_PATIENTID.%j.err
#SBATCH -D /path/to/dir

echo "SAMTOOLS MARKDUPLICATES FOR ID" >&2
module purge

apptainer \
exec \
--no-home \
--bind /scratch_isilon \
/scratch_isilon/groups/dat/apps/GATK/4.4.0.0/gatk_4.4.0.0.sif \
gatk --java-options "-Xmx6g" MarkDuplicates \
-I CHM13.ID.sort.bam \
-O CHM13.ID.sort.MD.bam \
-M CHM13.ID.sort.MD.txt

if [ $? -ne 0 ]; then
echo "JOB CANCEL : failed to MD for ID" >&2
exit 1
fi

printf END >&2; uptime >&2
